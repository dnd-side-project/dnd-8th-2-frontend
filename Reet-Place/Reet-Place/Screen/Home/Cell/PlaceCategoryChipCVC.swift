//
//  PlaceCategoryChipCVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/15.
//

class PlaceCategoryChipCVC: CategoryChipCVC {
    
    // MARK: - Variables and Properties
    
    private var categoryType: PlaceCategoryList?
    var delegate: CategoryChipCVCAction?
    
    // MARK: - Override
    
    override func didTapPlaceCategoryButton() {
        guard let categoryType = categoryType
        else {
            print("cannot find category place name")
            return
        }
        
        delegate?.tapCategoryChip(selectedCategory: categoryType)
    }
    
}

// MARK: - Configure

extension PlaceCategoryChipCVC {
    
    /// 홈 화면의 PlaceCategoryChipCVC 장소 정보 초기화
    func configurePlaceCategoryChipCVC(placeCategory: PlaceCategoryList) {
        categoryType = placeCategory
        placeCategoryButton.configureButton(with: placeCategory.description, for: .primary)
        
        if placeCategory == .reetPlaceHot {
            placeCategoryButton.isSelected = true
        }
    }
    
}
