//
//  DetailCategoryChipCVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/15.
//

import RxSwift

class DetailCategoryChipCVC: CategoryChipCVC {
    
    // MARK: - Variables and Properties
    
    private var delegateDetailCategoryChipAction: DetailCategoryChipAction?
    private var detailCategoryParameter: String?
    
    // MARK: - Override
    
    override func didTapPlaceCategoryButton() {
        let toUpdateSelection = !placeCategoryButton.isSelected
        if let delegate = delegateDetailCategoryChipAction,
           let detailCategoryParameter {
            placeCategoryButton.isSelected = delegate.updateSubCategorySelection(subCategory: detailCategoryParameter,
                                                                                 isSelected: toUpdateSelection)
            ? toUpdateSelection : !toUpdateSelection
        }
    }
    
    // MARK: - Functions
}

// MARK: - Configure

extension DetailCategoryChipCVC {
    
    /// 카테고리 세부 바텀시트에 표시되는 세부 장소 카테고리 셀 초기화시 사용
    func configureDetailPlaceCategoryChipCVC(detailCategoryTitle: String,
                                             detailCategoryParameter: String,
                                             isSelected: Bool,
                                             delegateDetailCategoryChipAction: DetailCategoryChipAction) {
        self.delegateDetailCategoryChipAction = delegateDetailCategoryChipAction
        self.detailCategoryParameter = detailCategoryParameter
        
        placeCategoryButton.configureButton(with: detailCategoryTitle, for: .primary)
        placeCategoryButton.isSelected = isSelected
    }
    
}
