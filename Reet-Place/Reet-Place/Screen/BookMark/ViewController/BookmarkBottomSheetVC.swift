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
    let placeInformationView = PlaceInformationView()
    
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
    
    // 릿플 점수
    let starTitle = BaseAttributedLabel(font: .subtitle2,
                                        text: "릿플 점수",
                                        alignment: .left,
                                        color: AssetColors.gray700)
    
    let starDesc = BaseAttributedLabel(font: .caption,
                                       text: .empty,
                                       alignment: .left,
                                       color: AssetColors.gray500)
    
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
    
    // 수정하기 버튼
    let modifyBtn = ReetButton(with: "수정하기",
                               for: ReetButtonStyle.secondary)
    
    // 해제하기 버튼
    let deleteBtn = UIButton(type: .system)
    
    let deleteStackView = UIStackView()
        .then {
            $0.spacing = 4.0
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .horizontal
            $0.isUserInteractionEnabled = false
        }
    
    let deleteImage = UIImageView(image: AssetsImages.delete)
        .then {
            $0.contentMode = .scaleAspectFit
        }
    
    let deleteLabel = BaseAttributedLabel(font: .buttonSmall,
                                          text: "해제하기",
                                          alignment: .left,
                                          color: AssetColors.error)
    
    let saveBtn = ReetButton(with: "저장하기",
                             for: ReetButtonStyle.primary)
    
    let popUp = ReetPopUp()
    
    
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
        placeInformationView.snp.makeConstraints {
            $0.top.equalTo(bottomSheetView.snp.top).offset(23)
            $0.leading.equalTo(bottomSheetView.snp.leading).offset(20)
            $0.trailing.equalTo(bottomSheetView.snp.trailing).offset(-20)
        }
        
        selectStackView.snp.makeConstraints {
            $0.top.equalTo(placeInformationView.snp.bottom).offset(16)
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
        
        modifyBtn.snp.makeConstraints {
            $0.leading.equalTo(bottomSheetView.snp.leading).offset(20)
            $0.trailing.equalTo(bottomSheetView.snp.trailing).offset(-20)
            $0.top.equalTo(bottomSheetView.snp.top).offset(476)
        }
        
        deleteBtn.snp.makeConstraints {
            $0.leading.equalTo(bottomSheetView.snp.leading).offset(20)
            $0.trailing.equalTo(bottomSheetView.snp.trailing).offset(-20)
            $0.top.equalTo(modifyBtn.snp.bottom).offset(8)
            $0.height.equalTo(48)
        }
        
        deleteStackView.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.centerX.equalTo(deleteBtn.snp.centerX)
            $0.centerY.equalTo(deleteBtn.snp.centerY)
        }
        
        saveBtn.snp.makeConstraints {
            $0.leading.equalTo(bottomSheetView.snp.leading).offset(20)
            $0.trailing.equalTo(bottomSheetView.snp.trailing).offset(-20)
            $0.top.equalTo(bottomSheetView.snp.top).offset(532)
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
                
                self.popUp.modalPresentationStyle = .overFullScreen
                self.present(self.popUp, animated: false)
            })
            .disposed(by: bag)
        
        // 팝업뷰 - 해제하기 버튼
        popUp.confirmBtn.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                print("TODO: - Delete Bookmark API to be call")
                self.dismissBottomSheet()
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
            starDesc.text = "가고싶은 기대감을 릿플 점수로 표현해주세요!"
        case 2:
            starDesc.text = "다녀온 이후의 만족도를 릿플 점수로 표현해주세요!"
        default:
            starDesc.text = "가고싶은 기대감을 릿플 점수로 표현해주세요!"
        }
    }
    
}
