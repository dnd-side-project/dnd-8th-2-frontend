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
    
    let placeNameView = UIView()
        .then {
            $0.backgroundColor = AssetColors.white
        }
    
    let placeNameLabel = BaseAttributedLabel(font: .h4,
                                        text: "Place Name",
                                        alignment: .left,
                                        color: AssetColors.black)
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
    
    let selectStackView = UIStackView()
        .then {
            $0.spacing = 12.0
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .vertical
        }
    
    let selectTypeBtn = SelectTypeButton()
    
    let toggleBtn = ToggleButton()
    
    let withPeopleTitle = BaseAttributedLabel(font: .subtitle2,
                                              text: "함께할 사람들",
                                              alignment: .left,
                                              color: AssetColors.gray700)
    
    let withPeopleTextField = UITextField()
        .then {
            $0.font = AssetFonts.body2.font
            $0.layer.borderColor = AssetColors.gray300.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 4.0
            $0.layer.masksToBounds = true
            $0.clearButtonMode = .whileEditing
            $0.attributedPlaceholder = NSAttributedString(
                string: "ex) 최나은, 박신영, 이다정",
                attributes: [NSAttributedString.Key.foregroundColor: AssetColors.gray500]
            )
            $0.addLeftPadding(padding: 12)
        }
    
    let urlTitle = BaseAttributedLabel(font: .subtitle2,
                                              text: "URL",
                                              alignment: .left,
                                              color: AssetColors.gray700)
    
    let urlStackView = UIStackView()
        .then {
            $0.spacing = 4.0
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .vertical
        }
    
    let firstUrl = UITextField()
        .then {
            $0.font = AssetFonts.body2.font
            $0.layer.borderColor = AssetColors.gray300.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 4.0
            $0.layer.masksToBounds = true
            $0.clearButtonMode = .whileEditing
            $0.attributedPlaceholder = NSAttributedString(
                string: "장소와 관련된 URL을 추가해주세요. (선택)",
                attributes: [NSAttributedString.Key.foregroundColor: AssetColors.gray500]
            )
            $0.addLeftPadding(padding: 12)
        }
    let secondUrl = UITextField()
        .then {
            $0.font = AssetFonts.body2.font
            $0.layer.borderColor = AssetColors.gray300.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 4.0
            $0.layer.masksToBounds = true
            $0.clearButtonMode = .whileEditing
            $0.attributedPlaceholder = NSAttributedString(
                string: "장소와 관련된 URL을 추가해주세요. (선택)",
                attributes: [NSAttributedString.Key.foregroundColor: AssetColors.gray500]
            )
            $0.addLeftPadding(padding: 12)
            $0.isHidden = true
        }
    let thirdUrl = UITextField()
        .then {
            $0.font = AssetFonts.body2.font
            $0.layer.borderColor = AssetColors.gray300.cgColor
            $0.layer.borderWidth = 1.0
            $0.layer.cornerRadius = 4.0
            $0.layer.masksToBounds = true
            $0.clearButtonMode = .whileEditing
            $0.attributedPlaceholder = NSAttributedString(
                string: "장소와 관련된 URL을 추가해주세요. (선택)",
                attributes: [NSAttributedString.Key.foregroundColor: AssetColors.gray500]
            )
            $0.addLeftPadding(padding: 12)
            $0.isHidden = true
        }
    
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
    
    let saveBtn = ReetButton(with: "저장하기",
                             for: ReetButtonStyle.primary)
    
    
    override func configureView() {
        super.configureView()
        
        sheetStyle = .h600

        view.addSubviews([placeNameView, saveBtn, selectStackView])
        
        [placeNameLabel, addressStackView].forEach {
            placeNameView.addSubview($0)
        }

        [addressLabel, addressBorder, categoryLabel].forEach {
            addressStackView.addArrangedSubview($0)
        }
        
        [selectTypeBtn, toggleBtn, withPeopleTitle, withPeopleTextField, urlTitle, urlStackView].forEach {
            selectStackView.addArrangedSubview($0)
        }
        selectStackView.setCustomSpacing(4.0, after: withPeopleTitle)
        selectStackView.setCustomSpacing(4.0, after: urlTitle)
        
        [firstUrl, secondUrl, thirdUrl, addBtn].forEach {
            urlStackView.addArrangedSubview($0)
        }
        
        bindBtn()
    }
    
    override func layoutView() {
        super.layoutView()
        
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
        
        [selectTypeBtn, toggleBtn, withPeopleTextField, firstUrl, secondUrl, thirdUrl].forEach {
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
    
    func bindBtn() {
        addBtn.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.addUrl()
            }
            .disposed(by: bag)
    }
    
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
