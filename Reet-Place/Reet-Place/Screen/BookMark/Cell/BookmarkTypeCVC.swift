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
            $0.contentMode = .scaleAspectFill
            $0.layer.borderColor = AssetColors.gray300.cgColor
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
    
    let titleImage = UIImageView(image: AssetsImages.markerRoundWishlist21)
        .then {
            $0.contentMode = .scaleAspectFit
        }
    
    let titleLabel = BaseAttributedLabel(font: AssetFonts.subtitle2,
                                         text: .empty,
                                         alignment: .left,
                                         color: AssetColors.black)
        .then {
            $0.textAlignment = .left
        }
    
    let countLabel = BaseAttributedLabel(font: AssetFonts.body2,
                                         text: .empty,
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
    
    func configureData(typeInfo: TypeInfo) {
        switch typeInfo.type {
        case "WANT":
            titleLabel.text = "BookmarkWishlist".localized
            titleImage.image = AssetsImages.markerRoundWishlist21
        case "GONE":
            titleLabel.text = "BookmarkHistory".localized
            titleImage.image = AssetsImages.markerRoundDidVisit21
        default:
            break
        }
        
        countLabel.text = String(typeInfo.cnt)
        
        // 북마크가 없으면 기본 이미지 노출
        if typeInfo.cnt > 0 {
            thumbnailImageView.contentMode = .scaleAspectFill
            thumbnailImageView.layer.borderWidth = 0.0
            
            // TODO: - UIImageView+의 setImage 함수 placeholder 파라미터 추가 됨 (임시 코드 - UIImage() 삽입)
            thumbnailImageView.setImage(with: typeInfo.thumbnailUrlString, placeholder: UIImage())
        } else {
            thumbnailImageView.contentMode = .scaleAspectFit
            thumbnailImageView.layer.borderWidth = 1.0
            thumbnailImageView.image = AssetsImages.noData160
        }
    }
    
}

// MARK: - Configure

extension BookmarkTypeCVC {
    
    private func configureContentView() {
        addSubviews([thumbnailImageView, stackView, countLabel])
        
        [titleImage, titleLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
    }
    
}


// MARK: - Layout

extension BookmarkTypeCVC {
    
    private func configureLayout() {
        stackView.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview()
            $0.height.equalTo(21.0)
        }
        
        countLabel.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview()
            $0.height.equalTo(21.0)
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top).offset(-12.0)
        }
    }
    
}
