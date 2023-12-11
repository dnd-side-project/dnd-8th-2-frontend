//
//  SearchResultTVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/06/21.
//

import UIKit

import SnapKit
import Then

import RxSwift
import RxGesture
import RxCocoa

class SearchResultTVC: BaseTableViewCell {
    
    // MARK: - UI components
    
    /// 장소 검색결과 목록의 기본 정보를 담는 StackView
    private let baseStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.alignment = .center
            $0.spacing = 12.0
        }
    
    private let thumbnailImageView = UIImageView()
        .then {
            $0.image = AssetsImages.placeResultThumbnail
            $0.contentMode = .scaleAspectFill
            
            $0.layer.cornerRadius = 4.0
            $0.layer.masksToBounds = true
        }
    private let bookmarkIconImageView = UIImageView()
        .then {
            $0.contentMode = .scaleAspectFit
        }
    
    /// 카테고리, 장소명, 주소가 들어가는 StackView
    private let placeInformationStackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 4.0
        }
    private let categoryLabel = BaseAttributedLabel(font: .caption,
                                                    text: .empty,
                                                    alignment: .left,
                                                    color: AssetColors.gray500)
    private let placeNameLabel = BaseAttributedLabel(font: .subtitle1,
                                                     text: .empty,
                                                     alignment: .left,
                                                     color: AssetColors.black)
    private let addressLabel = BaseAttributedLabel(font: .caption,
                                                   text: .empty,
                                                   alignment: .left,
                                                   color: AssetColors.gray500)
    
    private let cardMenuButton = UIButton(type: .system)
        .then {
            $0.setImage(AssetsImages.cardMenu24, for: .normal)
        }
    
    // MARK: - Variables and Properties
    
    private var cellIndex: Int?
    
    private var bag = DisposeBag()
    var delegateBookmarkCardAction: BookmarkCardAction?
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureTVC()
        bindMenuButton()
    }
    
    override func layoutView() {
        super.layoutView()

        configureLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnailImageView.image = AssetsImages.placeResultThumbnail
        bookmarkIconImageView.image = nil
        
        categoryLabel.text = nil
        placeNameLabel.text = nil
        addressLabel.text = nil
    }

    // MARK: - Function
}

// MARK: - Configure

extension SearchResultTVC {
    
    /// 검색결과 장소 셀의 데이터 정보를 입력하는 함수
    func configureSearchResultTVC(placeInfomation: SearchPlaceKeywordListContent, delegateBookmarkCardAction: BookmarkCardAction, cellIndex: Int) {
        self.delegateBookmarkCardAction = delegateBookmarkCardAction
        self.cellIndex = cellIndex
        
        // 1. 장소 썸네일 및 사용자 북마크
        if let thumbnailImage = placeInfomation.thumbnailImage {
            thumbnailImageView.setImage(with: thumbnailImage, placeholder: AssetsImages.placeResultThumbnail)
        }
        
        var groupIconImage: UIImage?
        switch BookmarkType(rawValue: placeInfomation.type ?? .empty) {
        case .want:
            groupIconImage = MarkerType.extended(.wishlist).image
        case .gone:
            groupIconImage = MarkerType.extended(.didVisit).image
        default:
            groupIconImage = nil
        }
        bookmarkIconImageView.image = groupIconImage
        
        // 2. 징소정보
        placeNameLabel.text = placeInfomation.name
        categoryLabel.text = PlaceCategoryList(rawValue: placeInfomation.category)?.description
        addressLabel.text = placeInfomation.roadAddress
    }
    
    private func configureTVC() {
        selectionStyle = .none
        contentView.isUserInteractionEnabled = false
    }
    
}

// MARK: - Layout

extension SearchResultTVC {
    
    private func configureLayout() {
        // Add Subviews
        addSubviews([baseStackView])
        
        [thumbnailImageView,
         placeInformationStackView,
         cardMenuButton].forEach {
            baseStackView.addArrangedSubview($0)
        }
        baseStackView.setCustomSpacing(0.0, after: placeInformationStackView)
        
        thumbnailImageView.addSubviews([bookmarkIconImageView])
        
        [categoryLabel,
         placeNameLabel,
         addressLabel].forEach {
            placeInformationStackView.addArrangedSubview($0)
        }
        
        // Make Constraints
        baseStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16.0)
            $0.horizontalEdges.equalToSuperview().inset(20.0)
        }
        
        placeInformationStackView.snp.makeConstraints {
            $0.height.equalTo(60.0)
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.width.height.equalTo(56.0)
        }
        bookmarkIconImageView.snp.makeConstraints {
            $0.width.height.equalTo(21.0)
            
            $0.top.leading.equalTo(thumbnailImageView).offset(4.0)
        }
        
        cardMenuButton.snp.makeConstraints {
            $0.width.height.equalTo(24.0)
        }
    }
    
}

// MARK: - Bind

extension SearchResultTVC {
    
    private func bindMenuButton() {
        cardMenuButton.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self,
                      let cellIndex = self.cellIndex,
                      let owner = self.findViewController() else { return }
                
                let buttonFrameInSuperview = owner.view.convert(self.cardMenuButton.frame, from: self.baseStackView)
                self.delegateBookmarkCardAction?.showMenu(index: cellIndex, location: buttonFrameInSuperview, selectMenuType: self.bookmarkIconImageView.image == nil ? .defaultPlaceInfo : .bookmarked)
            })
            .disposed(by: bag)
    }
    
}
