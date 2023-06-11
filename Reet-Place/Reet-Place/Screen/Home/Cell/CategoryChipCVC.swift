//
//  CategoryChipCVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/26.
//

import UIKit

import Then
import SnapKit

import RxSwift
import RxCocoa

class CategoryChipCVC: BaseCollectionViewCell {
    
    // MARK: - UI components
    
    let placeCategoryButton = CategoryChipButton(frame: .zero, with: .empty, style: .primary)
    
    // MARK: - Variables and Properties
    
    var title: String?
    
    private var bag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        _ = placeCategoryButton
            .then {
                $0.title = .empty
                $0.isSelected = false
            }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        placeCategoryButton.clipsToBounds = true
        placeCategoryButton.layer.cornerRadius = contentView.frame.height / 2.0
    }
    
    override func configureView() {
        super.configureView()
        
        bindButton()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Override
    
    override var isSelected: Bool {
        didSet {
            placeCategoryButton.isSelected = isSelected
        }
    }
    
    // MARK: - Functions
}

// MARK: - Configure

extension CategoryChipCVC {
    
    /// Use when collectionView data binding
    func configureCategoryChipCVC(category: PlaceCategoryList) {
        title = category.description
        placeCategoryButton.configureButton(with: category.description, for: .primary)
        
        if category == .reetPlaceHot {
            placeCategoryButton.isSelected = true
        }
    }
    
    /// 카테고리 세부 바텀시트에 표시되는 세부 장소 카테고리 셀 초기화시 사용
    func configureDetailPlaceCategoryChipCVC(category: String) {
        title = category
        placeCategoryButton.configureButton(with: category, for: .primary)
    }
    
}

// MARK: - Layout

extension CategoryChipCVC {
    
    private func configureLayout() {
        contentView.addSubviews([placeCategoryButton])
        
        placeCategoryButton.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }
    
}

// MARK: - Input

extension CategoryChipCVC {
    
    private func bindButton() {
        placeCategoryButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                
                isSelected = !isSelected
            })
            .disposed(by: bag)
    }
    
}
