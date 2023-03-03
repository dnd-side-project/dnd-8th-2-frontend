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
    
    var category: PlaceCategoryList?
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
    
    // MARK: - Functions
}

// MARK: - Configure

extension CategoryChipCVC {
    
    /// Use when collectionView data binding
    func configureCategoryChipCVC(category: PlaceCategoryList) {
        self.category = category
        placeCategoryButton.configureButton(with: category.description, for: .primary)
        
        if category == .reetPlaceHot {
            placeCategoryButton.isSelected = true
        }
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
                print("TODO: - Category BottomSheet ", self.category)
            })
            .disposed(by: bag)
    }
    
}
