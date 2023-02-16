//
//  BookmarkTypeCVC.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/17.
//

import UIKit

import Then
import SnapKit

class BookmarkTypeCVC: BaseCollectionViewCell {
    // MARK: - UI components
    
    let thumbnailImageView = UIImageView()
        .then {
            $0.backgroundColor = AssetColors.gray300
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 8.0
            $0.layer.masksToBounds = true
        }
    
    let titleLabel = BaseLabel(font: AssetFonts.subtitle2, text: "가고싶어요", color: AssetColors.black)
        .then {
            $0.textAlignment = .left
        }
    
    let countLabel = BaseLabel(font: AssetFonts.body2, text: "17", color: AssetColors.primary500)
        .then {
            $0.textAlignment = .right
        }
    
    // MARK: - Variables and Properties
    
    
    // MARK: - Life Cycle
    override func configureView() {
        super.configureView()
        
        addSubviews([thumbnailImageView, titleLabel, countLabel])
    }
    
    override func layoutView() {
        super.layoutView()
        
        titleLabel.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview()
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top).offset(-8)
        }
    }

    // MARK: - Function
    
}
