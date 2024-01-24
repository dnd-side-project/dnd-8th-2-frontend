//
//  DetailCategoryChipAction.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/10/28.
//

import UIKit

/// DetailCategoryChipCVC와 관련된 작업 등을 정의
protocol DetailCategoryChipAction {
    
    /// 세부 카테고리 칩 버튼을 클릭했을 때 호출
    func updateSubCategorySelection(category: String ,isSelected: Bool)
    
}
