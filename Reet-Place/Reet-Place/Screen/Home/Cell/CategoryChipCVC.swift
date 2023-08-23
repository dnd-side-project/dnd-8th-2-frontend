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

/// 카테고리 칩과 관련된 액션을 정의
protocol CategoryChipCVCAction {
    /// 선택된 카테고리 종류를 파라미터 값으로 전달 및 액션 구현
    func tapCategoryChip(selectedCategory: PlaceCategoryList)
}

class CategoryChipCVC: BaseCollectionViewCell {
    
    // MARK: - UI components
    
    let placeCategoryButton = CategoryChipButton(frame: .zero, with: .empty, style: .primary)
    
    // MARK: - Variables and Properties
    
    private var bag = DisposeBag()
    
    // MARK: - Life Cycle
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        placeCategoryButton.title = .empty
    }
    
    // MARK: - Functions
    
    /// CategoryChip 내부 placeCategoryButton이 눌렸을 때 호출되는 함수
    func didTapPlaceCategoryButton() {}
    
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
                
                self.didTapPlaceCategoryButton()
            })
            .disposed(by: bag)
    }
    
}
