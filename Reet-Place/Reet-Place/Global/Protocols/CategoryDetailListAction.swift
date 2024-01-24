//
//  CategoryDetailListAction.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/10/28.
//

import UIKit

/// CategoryDetailListCVC와 관련된 작업 등을 정의
protocol CategoryDetailListAction {
    
    /// FilterBottomSheet에게 현재 선택된 SubCategory 값을 갱신
    func updateSubCategorySelection(category: String, subCategory: String, isSelected: Bool)
    
    /// CategoryDetailListCVC에 저장되어 있는 categoryList 데이터(PlaceCategoryModel)를 반환
    func getPlaceCategoryModel(categoryList: PlaceCategoryModel)
    
}
