//
//  BookmarkBottomSheetVC.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/25.
//

import UIKit

import SnapKit
import Then

import RxSwift
import RxGesture
import RxCocoa

class BookmarkBottomSheetVC: ReetBottomSheet {
    
    // MARK: - UI components
    
    override var alias: String {
        "BookmarkBottomSheet"
    }
    
    // Place Name, address, category 들어가는 View
    let placeNameView = UIView()
        .then {
            $0.backgroundColor = AssetColors.white
        }
    
    let placeNameLabel = BaseAttributedLabel(font: .h4,
                                        text: "Place Name",
                                        alignment: .left,
                                        color: AssetColors.black)
    
    // address, border, category 들어가는 stackView
    let addressStackView = UIStackView()
        .then {
            $0.spacing = 8.0
            $0.distribution = .fill
            $0.alignment = .center
            $0.axis = .horizontal
        }
    
    let addressLabel = BaseAttributedLabel(font: .caption,
                                           text: "하남 미사",
                                           alignment: .center,
                                           color: AssetColors.gray700)
    
    let addressBorder = UIView()
        .then {
            $0.backgroundColor = AssetColors.gray500
        }
    
    let categoryLabel = BaseAttributedLabel(font: .caption,
                                            text: "카페",
                                            alignment: .center,
                                            color: AssetColors.gray700)
    
    // 아래 선택지들 들어가는 stackView
    let selectStackView = UIStackView()
        .then {
            $0.spacing = 12.0
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .vertical
        }
    
    // 가고싶어요, 다녀왔어요
    let selectTypeBtn = SelectTypeButton()
    
    // 별 개수 선택
    let starToggleBtn = StarToggleButton()
    
    // 함께할 사람들
    let withPeopleTitle = BaseAttributedLabel(font: .subtitle2,
                                              text: "함께할 사람들",
                                              alignment: .left,
                                              color: AssetColors.gray700)
    
    let withPeopleTextField = ReetTextField(style: .normal,
                                            placeholderString: "ex) 최나은, 박신영, 이다정",
                                            textString: nil)
    
    // 관련 URL
    let urlTitle = BaseAttributedLabel(font: .subtitle2,
                                              text: "URL",
                                              alignment: .left,
                                              color: AssetColors.gray700)
    
    // URL 들어가는 stackView, 첫번째 url 제외하고 숨김
    let urlStackView = UIStackView()
        .then {
            $0.spacing = 4.0
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .vertical
        }
    
    let firstUrl = ReetTextField(style: .normal,
                                 placeholderString: "장소와 관련된 URL을 추가해주세요. (선택)",
                                 textString: nil)
    
    let secondUrl = ReetTextField(style: .normal,
                                  placeholderString: "장소와 관련된 URL을 추가해주세요. (선택)",
                                  textString: nil)
        .then {
            $0.isHidden = true
        }
    
    let thirdUrl = ReetTextField(style: .normal,
                                 placeholderString: "장소와 관련된 URL을 추가해주세요. (선택)",
                                 textString: nil)
        .then {
            $0.isHidden = true
        }
    
    // URL 추가 버튼
    let addBtn = UIButton()
        .then {
            $0.setTitle("+", for: .normal)
            $0.setTitleColor(AssetColors.gray300, for: .normal)
            $0.setBackgroundColor(AssetColors.gray100, for: .normal)
            $0.setBackgroundColor(AssetColors.gray200, for: .highlighted)
            $0.layer.borderColor = AssetColors.gray300.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 4.0
            $0.layer.masksToBounds = true
        }
    
    // 저장하기 버튼
    let saveBtn = ReetButton(with: "저장하기",
                             for: ReetButtonStyle.primary)
    
    
    // MARK: - Variables and Properties
    
    var urlField : [ReetTextField] = []
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindRx() {
        super.bindRx()
        
        bindAddBtn()
        bindKeyboard()
    }
    
    
    // MARK: - Functions
    
    func addUrl() {
        if secondUrl.isHidden {
            secondUrl.isHidden = false
            view.layoutIfNeeded()
            return
        }
        
        if thirdUrl.isHidden {
            thirdUrl.isHidden = false
            addBtn.isHidden = true
            view.layoutIfNeeded()
            return
        }
    }
    
}


// MARK: - Configure

extension BookmarkBottomSheetVC {
    
    private func configureContentView() {
        sheetStyle = .h600

        view.addSubviews([placeNameView, saveBtn, selectStackView])
        
        [placeNameLabel, addressStackView].forEach {
            placeNameView.addSubview($0)
        }

        [addressLabel, addressBorder, categoryLabel].forEach {
            addressStackView.addArrangedSubview($0)
        }
        
        [selectTypeBtn, starToggleBtn, withPeopleTitle, withPeopleTextField, urlTitle, urlStackView].forEach {
            selectStackView.addArrangedSubview($0)
        }
        
        [withPeopleTitle, urlTitle].forEach {
            selectStackView.setCustomSpacing(4.0, after: $0)
        }
        
        [firstUrl, secondUrl, thirdUrl, addBtn].forEach {
            urlStackView.addArrangedSubview($0)
        }
        
    }
    
    func configureSheetData(with cardInfo: BookmarkCardModel) {
        placeNameLabel.text = cardInfo.placeName
        addressLabel.text = cardInfo.address
        categoryLabel.text = cardInfo.categoryName
        
        [firstUrl, secondUrl, thirdUrl].forEach {
            urlField.append($0)
        }
        
        cardInfo.groupType == "가고싶어요"
        ? selectTypeBtn.selectType(selectTypeBtn.wishBtn)
        : selectTypeBtn.selectType(selectTypeBtn.historyBtn)
        
        switch cardInfo.starCount {
        case 1:
            starToggleBtn.oneStarBtn.isSelected = true
        case 2:
            starToggleBtn.twoStarBtn.isSelected = true
        case 3:
            starToggleBtn.threeStarBtn.isSelected = true
        default:
            starToggleBtn.threeStarBtn.isSelected = true
        }
        
        if !cardInfo.withPeople.isEmpty {
            withPeopleTextField.text = cardInfo.withPeople
        }
        
        for (index, url) in [cardInfo.relLink1, cardInfo.relLink2, cardInfo.relLink3].enumerated() {
            if let url = url {
                urlField[index].text = url
                urlField[index].isHidden = false
                
                if index == 3 {
                    addBtn.isHidden = true
                }
            }
        }

    }
    
}


// MARK: - Layout

extension BookmarkBottomSheetVC {
    
    private func configureLayout() {
        placeNameView.snp.makeConstraints {
            $0.top.equalTo(bottomSheetView.snp.top).offset(23)
            $0.leading.equalTo(bottomSheetView.snp.leading).offset(20)
            $0.trailing.equalTo(bottomSheetView.snp.trailing).offset(-20)
            $0.height.equalTo(50)
        }
        
        placeNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        addressBorder.snp.makeConstraints {
            $0.height.equalTo(8)
            $0.width.equalTo(1)
        }
        
        addressStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        selectStackView.snp.makeConstraints {
            $0.top.equalTo(placeNameView.snp.bottom).offset(16)
            $0.leading.equalTo(bottomSheetView.snp.leading).offset(20)
            $0.trailing.equalTo(bottomSheetView.snp.trailing).offset(-20)
        }
        
        [selectTypeBtn, starToggleBtn, withPeopleTextField, firstUrl, secondUrl, thirdUrl].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(40)
            }
        }
        
        [withPeopleTitle, urlTitle].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(20)
            }
        }

        addBtn.snp.makeConstraints {
            $0.height.equalTo(28)
        }
        
        saveBtn.snp.makeConstraints {
            $0.leading.equalTo(bottomSheetView.snp.leading).offset(20)
            $0.trailing.equalTo(bottomSheetView.snp.trailing).offset(-20)
            $0.top.equalTo(bottomSheetView.snp.top).offset(516)
        }
    }
    
}


// MARK: - Bind

extension BookmarkBottomSheetVC {
    
    private func bindKeyboard() {
        keyboardWillShow
            .compactMap { $0.userInfo }
            .map { userInfo -> CGFloat in
                return (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
            }
            .subscribe(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }
                self.bottomSheetView.snp.updateConstraints {
                    $0.height.equalTo(self.sheetHeight + keyboardHeight - 170)
                }
                self.view.layoutIfNeeded()
            })
            .disposed(by: bag)
        
        keyboardWillHide
            .compactMap { $0.userInfo }
            .map { userInfo -> CGFloat in
                return (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
            }
            .subscribe(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }
                self.bottomSheetView.snp.updateConstraints {
                    $0.height.equalTo(self.sheetHeight)
                }
                self.view.layoutIfNeeded()
            })
            .disposed(by: bag)
    }
    
    private func bindAddBtn() {
        addBtn.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.addUrl()
            }
            .disposed(by: bag)
    }
    
}
