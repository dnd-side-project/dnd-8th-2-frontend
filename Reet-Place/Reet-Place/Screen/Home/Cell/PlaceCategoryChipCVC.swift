//
//  PlaceCategoryChipCVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/15.
//

class PlaceCategoryChipCVC: CategoryChipCVC {
    
    // MARK: - Variables and Properties
    
    private var categoryType: PlaceCategoryList?
    
    // MARK: - Override
    
    override var isSelected: Bool {
        didSet {
            placeCategoryButton.isSelected = isSelected
        }
    }
    
}

// MARK: - Configure

extension PlaceCategoryChipCVC {
    
    /// 홈 화면의 PlaceCategoryChipCVC 장소 정보 초기화
    func configurePlaceCategoryChipCVC(placeCategory: PlaceCategoryList) {
        categoryType = placeCategory
        
        placeCategoryButton.configureButton(with: placeCategory.description, for: .primary)
        placeCategoryButton.isSelected = isSelected
        placeCategoryButton.isUserInteractionEnabled = false
    }
    
}
