//
//  BookmarkCardTVC.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/18.
//

import UIKit

import SnapKit
import Then

import RxSwift
import RxGesture
import RxCocoa

class BookmarkCardTVC: BaseTableViewCell {
    
    // MARK: - UI components
    
    private let bookmarkDataStackView = UIStackView()
        .then {
            $0.spacing = 8.0
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .vertical
        }
    private let thumbnailImageView = UIImageView()
        .then {
            $0.backgroundColor = AssetColors.gray300
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 4.0
            $0.layer.masksToBounds = true
        }
    private let placeInformationView = PlaceInfoView()
    
    private let contentBorder = UIView()
        .then {
            $0.backgroundColor = AssetColors.gray300
        }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureTVC()
    }
    
    override func layoutView() {
        super.layoutView()

        configureLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        placeInformationView.prepareForReuseCell()
    }

    // MARK: - Function
}

// MARK: - Configure

extension BookmarkCardTVC {
    
    /// 사용자의 북마크카드 정보를 입력하는 함수
    func configureBookmarkCardTVC(with cardInfo: BookmarkCardModel, bookmarkCardActionDelegate: BookmarkCardAction, index: Int) {
        placeInformationView.configurePlaceInfoView(cardInfo: cardInfo,
                                                    delegate: bookmarkCardActionDelegate,
                                                    cellIndex: index)
        
        // TODO: - UIImageView+의 setImage 함수 placeholder 파라미터 추가 됨 (임시 코드 - UIImage() 삽입)
        thumbnailImageView.setImage(with: cardInfo.thumbnailImage, placeholder: UIImage())
    }
    
    private func configureTVC() {
        selectionStyle = .none
    }
    
}

// MARK: - Layout

extension BookmarkCardTVC {
    
    private func configureLayout() {
        // Add Subviews
        contentView.addSubviews([bookmarkDataStackView,
                                 contentBorder])
        [thumbnailImageView,
         placeInformationView].forEach {
            bookmarkDataStackView.addArrangedSubview($0)
        }
        
        // Make Constraints
        bookmarkDataStackView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(16.0)
            $0.horizontalEdges.equalTo(contentView).inset(20.0)
        }
        thumbnailImageView.snp.makeConstraints {
            $0.height.equalTo(96.0)
        }
        
        contentBorder.snp.makeConstraints {
            $0.height.equalTo(0.5)
            
            $0.top.equalTo(bookmarkDataStackView.snp.bottom).offset(16.0).priority(.low)
            $0.horizontalEdges.bottom.equalTo(contentView)
        }
    }
 
}
