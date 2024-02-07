//
//  PlaceResultListCVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/12/19.
//

import UIKit

import Then
import SnapKit

import RxSwift
import RxCocoa

class PlaceResultListCVC: BaseCollectionViewCell {
    
    // MARK: - UI components
    
    private let baseStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.alignment = .top
            $0.spacing = 12.0
        }
    private let thumbnailImageView = UIImageView()
        .then {
            $0.image = AssetsImages.placeResultThumbnail
            
            $0.contentMode = .scaleAspectFill
            $0.layer.borderColor = AssetColors.gray300.cgColor
            $0.layer.cornerRadius = 4.0
            $0.layer.masksToBounds = true
        }
    private let placeInformationView = PlaceInformationView(placeNameFont: .subtitle1)
    
    // MARK: - Variables and Properties
    
    private var bag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnailImageView.image = AssetsImages.placeResultThumbnail
    }
    
    // MARK: - Functions
}

// MARK: - Configure

extension PlaceResultListCVC {
    
    /// 카테고리 장소검색 결과 목록 PlaceResultListCVC 정보 초기화
    func configurePlaceResultListCVC(placeResultInfo: SearchPlaceListContent) {
        if let thumbnailImage = placeResultInfo.thumbnailImage {
            thumbnailImageView.setImage(with: thumbnailImage, placeholder: AssetsImages.placeResultThumbnail)
        }
        
        var simpleAddress: String = .empty
        let addressList = placeResultInfo.lotNumberAddress.split(separator: " ")
        if let city = addressList[safe: 11],
           let dong = addressList[safe: 21] {
            simpleAddress = city + " " + dong
        }
        
        placeInformationView.configurePlaceInfomation(
            placeName: placeResultInfo.name,
            address: simpleAddress,
            category: PlaceCategoryList(rawValue: placeResultInfo.category).name
        )
    }
    
    private func configureContentView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8.0
        contentView.addShadow()
    }
    
}

// MARK: - Layout

extension PlaceResultListCVC {
    
    private func configureLayout() {
        contentView.addSubviews([baseStackView])
        [thumbnailImageView,
         placeInformationView].forEach {
            baseStackView.addArrangedSubview($0)
        }
        
        baseStackView.snp.makeConstraints {
            $0.edges.equalTo(contentView).inset(12.0)
        }
        placeInformationView.snp.updateConstraints {
            $0.height.equalTo(46.0)
        }
        thumbnailImageView.snp.makeConstraints {
            $0.width.height.equalTo(56.0)
        }
    }
    
}
