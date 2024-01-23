//
//  DetailCategoryChipCVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/15.
//

import RxSwift

class DetailCategoryChipCVC: CategoryChipCVC {
    
    // MARK: - Variables and Properties
    
    private var detailCategoryTitle: String?
    private var detailCategoryParameter: String?
    
    // MARK: - Override
    
    override func didTapPlaceCategoryButton() {
        placeCategoryButton.isSelected = !placeCategoryButton.isSelected
        
        // TODO: - 선택변경된 카테고리 값 FilterSheet 내부 데이터에 반영
        print(detailCategoryTitle, detailCategoryParameter, placeCategoryButton.isSelected)
    }
    
    // MARK: - Functions
    
    /// 세부 카테고리 이름 반환
    func getDetailCategoryTitle() -> String? {
        return detailCategoryTitle
    }
    
    /// 세부 카테고리 서버 요청 파라미터 반환
    func getDetailCategoryParameter() -> String? {
        return detailCategoryParameter
    }
    
}

// MARK: - Configure

extension DetailCategoryChipCVC {
    
    /// 카테고리 세부 바텀시트에 표시되는 세부 장소 카테고리 셀 초기화시 사용
    func configureDetailPlaceCategoryChipCVC(detailCategoryTitle: String, detailCategoryParameter: String) {
        self.detailCategoryTitle = detailCategoryTitle
        self.detailCategoryParameter = detailCategoryParameter
        placeCategoryButton.configureButton(with: detailCategoryTitle, for: .primary)
        
        placeCategoryButton.isSelected = true
    }
    
}
