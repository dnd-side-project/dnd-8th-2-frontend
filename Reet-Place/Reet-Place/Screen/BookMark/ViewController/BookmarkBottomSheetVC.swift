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
    private let placeInformationView = PlaceInformationView()
    
    // 아래 선택지들 들어가는 stackView
    private let selectStackView = UIStackView()
        .then {
            $0.spacing = 12.0
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .vertical
        }
    
    // 가고싶어요, 다녀왔어요
    private let selectTypeBtn = SelectTypeButton()
    
    // 릿플 점수
    private let starTitle = BaseAttributedLabel(font: .subtitle2,
                                                text: "ReetPlacePoint".localized,
                                                alignment: .left,
                                                color: AssetColors.gray700)
    
    private let starDesc = BaseAttributedLabel(font: .caption,
                                               text: .empty,
                                               alignment: .left,
                                               color: AssetColors.gray500)
    
    // 별 개수 선택
    private let starToggleBtn = StarToggleButton()
    
    // 함께할 사람들
    private let withPeopleTitle = BaseAttributedLabel(font: .subtitle2,
                                                      text: "WithPeopleTitle".localized,
                                                      alignment: .left,
                                                      color: AssetColors.gray700)
    
    private let withPeopleTextField = ReetTextField(style: .normal,
                                                    placeholderString: "WithPeoplePlaceHolder".localized,
                                                    textString: .empty)
    
    // 관련 URL
    private let urlTitle = BaseAttributedLabel(font: .subtitle2,
                                              text: "URL",
                                              alignment: .left,
                                              color: AssetColors.gray700)
    
    // URL 들어가는 stackView, 첫번째 url 제외하고 숨김
    private let urlStackView = UIStackView()
        .then {
            $0.spacing = 4.0
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .vertical
        }
    
    private let firstUrl = ReetTextField(style: .normal,
                                         placeholderString: "RelatedUrlPlaceHolder".localized,
                                         textString: .empty)
    
    private let secondUrl = ReetTextField(style: .normal,
                                          placeholderString: "RelatedUrlPlaceHolder".localized,
                                          textString: .empty)
        .then {
            $0.isHidden = true
        }
    
    private let thirdUrl = ReetTextField(style: .normal,
                                         placeholderString: "RelatedUrlPlaceHolder".localized,
                                         textString: .empty)
        .then {
            $0.isHidden = true
        }
    
    // URL 추가 버튼
    private let addBtn = UIButton()
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
    
    // 수정하기 버튼
    private let modifyBtn = ReetButton(with: "ModifyBtn".localized,
                                       for: ReetButtonStyle.secondary)
    
    // 해제하기 버튼
    private let deleteBtn = UIButton(type: .system)
    
    private let deleteStackView = UIStackView()
        .then {
            $0.spacing = 4.0
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .horizontal
            $0.isUserInteractionEnabled = false
        }
    
    private let deleteImage = UIImageView(image: AssetsImages.delete)
        .then {
            $0.contentMode = .scaleAspectFit
        }
    
    private let deleteLabel = BaseAttributedLabel(font: .buttonSmall,
                                                  text: "DeleteBtn".localized,
                                                  alignment: .left,
                                                  color: AssetColors.error)
    
    private let saveBtn = ReetButton(with: "SaveBookmark".localized,
                                     for: ReetButtonStyle.primary)
    
    private let popUp = ReetPopUp()
    
    
    // MARK: - Variables and Properties
    
    var urlField : [ReetTextField] = []
    
    var isBookmarking = true
    
    
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
        
        bindBtn()
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
    
    @objc func deleteBookmark() {
        self.dismissBottomSheet()
        print("TODO: - Delete Bookmark API to be call")
    }
    
}


// MARK: - Configure

extension BookmarkBottomSheetVC {
    
    private func configureContentView() {
        sheetStyle = .h616

        view.addSubviews([placeInformationView, modifyBtn, selectStackView, deleteBtn, saveBtn])
        
        [selectTypeBtn,
         starTitle,
         starDesc,
         starToggleBtn,
         withPeopleTitle,
         withPeopleTextField,
         urlTitle,
         urlStackView].forEach {
            selectStackView.addArrangedSubview($0)
        }
        
        [starTitle, starDesc].forEach {
            selectStackView.setCustomSpacing(5.0, after: $0)
        }
        
        [withPeopleTitle, urlTitle].forEach {
            selectStackView.setCustomSpacing(4.0, after: $0)
        }
        
        [firstUrl, secondUrl, thirdUrl, addBtn].forEach {
            urlStackView.addArrangedSubview($0)
        }
        
        deleteBtn.addSubview(deleteStackView)
        
        [deleteImage, deleteLabel].forEach {
            deleteStackView.addArrangedSubview($0)
        }
        
        modifyBtn.isHidden = !isBookmarking
        deleteBtn.isHidden = !isBookmarking
        saveBtn.isHidden = isBookmarking
        
    }
    
    func configureSheetData(with cardInfo: BookmarkCardModel) {
        placeInformationView.configurePlaceInfomation(placeName: cardInfo.placeName,
                                                      address: cardInfo.address,
                                                      category: cardInfo.categoryName)
        
        [firstUrl, secondUrl, thirdUrl].forEach {
            urlField.append($0)
        }
        
        selectTypeBtn.delegate = self
        
        cardInfo.groupType == "WANT"
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
        
        let urlList = [cardInfo.relLink1, cardInfo.relLink2, cardInfo.relLink3].filter { $0 != "null" }
        for (index, url) in urlList.enumerated() {
            urlField[index].text = url
            urlField[index].isHidden = false
            
            if index == 3 {
                addBtn.isHidden = true
            }
        }

    }
    
}


// MARK: - Layout

extension BookmarkBottomSheetVC {
    
    private func configureLayout() {
        placeInformationView.snp.makeConstraints {
            $0.top.equalTo(bottomSheetView.snp.top).offset(23.0)
            $0.leading.equalTo(bottomSheetView.snp.leading).offset(20.0)
            $0.trailing.equalTo(bottomSheetView.snp.trailing).offset(-20.0)
        }
        
        selectStackView.snp.makeConstraints {
            $0.top.equalTo(placeInformationView.snp.bottom).offset(16.0)
            $0.leading.equalTo(bottomSheetView.snp.leading).offset(20.0)
            $0.trailing.equalTo(bottomSheetView.snp.trailing).offset(-20.0)
        }
        
        [selectTypeBtn, starToggleBtn, withPeopleTextField, firstUrl, secondUrl, thirdUrl].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(40.0)
            }
        }
        
        [withPeopleTitle, urlTitle].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(20.0)
            }
        }

        addBtn.snp.makeConstraints {
            $0.height.equalTo(28.0)
        }
        
        modifyBtn.snp.makeConstraints {
            $0.leading.equalTo(bottomSheetView.snp.leading).offset(20.0)
            $0.trailing.equalTo(bottomSheetView.snp.trailing).offset(-20.0)
            $0.top.equalTo(bottomSheetView.snp.top).offset(476.0)
        }
        
        deleteBtn.snp.makeConstraints {
            $0.leading.equalTo(bottomSheetView.snp.leading).offset(20.0)
            $0.trailing.equalTo(bottomSheetView.snp.trailing).offset(-20.0)
            $0.top.equalTo(modifyBtn.snp.bottom).offset(8.0)
            $0.height.equalTo(48.0)
        }
        
        deleteStackView.snp.makeConstraints {
            $0.height.equalTo(16.0)
            $0.centerX.equalTo(deleteBtn.snp.centerX)
            $0.centerY.equalTo(deleteBtn.snp.centerY)
        }
        
        saveBtn.snp.makeConstraints {
            $0.leading.equalTo(bottomSheetView.snp.leading).offset(20.0)
            $0.trailing.equalTo(bottomSheetView.snp.trailing).offset(-20.0)
            $0.top.equalTo(bottomSheetView.snp.top).offset(532.0)
        }
    }
    
}


// MARK: - Bind

extension BookmarkBottomSheetVC {
    
    private func bindKeyboard() {
        // 키보드가 올라올 때
        keyboardWillShow
            .compactMap { $0.userInfo }
            .map { userInfo -> CGFloat in
                return (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
            }
            .subscribe(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }
                self.bottomSheetView.snp.updateConstraints {
                    $0.height.equalTo(self.sheetHeight + keyboardHeight - 130)
                }
                self.view.layoutIfNeeded()
            })
            .disposed(by: bag)
        
        // 키보드가 내려갈 때
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
    
    private func bindBtn() {
        // 관련 url 추가
        addBtn.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.addUrl()
            })
            .disposed(by: bag)
        
        // 수정하기 버튼
        modifyBtn.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                print("TODO: - Modify Bookmark API to be call")
                self.dismissBottomSheet()
            })
            .disposed(by: bag)
        
        // 삭제하기 버튼
        deleteBtn.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.showPopUp(popUpType: .deleteBookmark,
                               targetVC: self,
                               confirmBtnAction: #selector(self.deleteBookmark))
            })
            .disposed(by: bag)

        
        // 저장하기 버튼
        saveBtn.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                print("TODO: - Save Bookmark API to be call")
                self.dismissBottomSheet()
            })
            .disposed(by: bag)
    }
    
}


extension BookmarkBottomSheetVC: TypeSelectAction {
    
    func typeChange(type: Int) {
        switch type {
        case 1:
            starDesc.text = "WishTypePointDesc".localized
        case 2:
            starDesc.text = "HistoryTypePointDesc".localized
        default:
            starDesc.text = "WishTypePointDesc".localized
        }
    }
    
}
