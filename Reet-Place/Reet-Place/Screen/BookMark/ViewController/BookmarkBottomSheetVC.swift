//
//  BookmarkBottomSheetVC.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/25.
//

import UIKit

import SnapKit
import Then

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
    
    let toggleBtn = ToggleButton()
    
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
        
        selectStackView.addArrangedSubview(toggleBtn)
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
        
        toggleBtn.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        
        saveBtn.snp.makeConstraints {
            $0.leading.equalTo(bottomSheetView.snp.leading).offset(20)
            $0.trailing.equalTo(bottomSheetView.snp.trailing).offset(-20)
            $0.top.equalTo(bottomSheetView.snp.top).offset(516)
        }
    }
    
}
