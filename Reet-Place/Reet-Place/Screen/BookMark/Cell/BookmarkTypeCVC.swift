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
    
    let stackView = UIStackView()
        .then {
            $0.spacing = 10.0
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .horizontal
        }
    
    let titleLabel = BaseAttributedLabel(font: AssetFonts.subtitle2,
                                         text: "가고싶어요",
                                         alignment: .left,
                                         color: AssetColors.black)
        .then {
            $0.textAlignment = .left
        }
    
    let countLabel = BaseAttributedLabel(font: AssetFonts.body2,
                                         text: "17",
                                         alignment: .left,
                                         color: AssetColors.gray500)
        .then {
            $0.textAlignment = .right
        }
    
    // MARK: - Variables and Properties
    
    
    // MARK: - Life Cycle
    override func configureView() {
        super.configureView()
        
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }

    // MARK: - Function
    
}

// MARK: - Configure

extension BookmarkTypeCVC {
    
    private func configureContentView() {
        addSubviews([thumbnailImageView, titleLabel, countLabel])
    }
    
}


// MARK: - Layout

extension BookmarkTypeCVC {
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview()
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top).offset(-12)
        }
    }
    
}
