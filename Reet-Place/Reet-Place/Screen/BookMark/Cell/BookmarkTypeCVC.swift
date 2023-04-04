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
    
    func configureData(type: String, count: Int) {
        switch type {
        case "wish":
            titleLabel.text = "가고싶어요"
            titleImage.image = AssetsImages.markerRoundWishlist21
        case "visit":
            titleLabel.text = "다녀왔어요"
            titleImage.image = AssetsImages.markerRoundDidVisit21
        default:
            break
        }
        
        countLabel.text = String(count)
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
            $0.height.equalTo(21)
        }
        
        countLabel.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview()
            $0.height.equalTo(21)
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top).offset(-12)
        }
    }
    
}
