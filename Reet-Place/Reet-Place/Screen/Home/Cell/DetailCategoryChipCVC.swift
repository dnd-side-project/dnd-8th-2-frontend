//
//  DetailCategoryChipCVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/15.
//

class DetailCategoryChipCVC: CategoryChipCVC {
    
    // MARK: - Variables and Properties
    
    private var detailCategoryTitle: String?
    
    // MARK: - Override
    
    override var isSelected: Bool {
        didSet {
            placeCategoryButton.isSelected = isSelected
        }
    }
    
    override func didTapPlaceCategoryButton() {
        isSelected.toggle()
    }
    
    // MARK: - Functions
    
    /// 세부 카테고리
    func getDetailCategoryTitle() -> String? {
        return detailCategoryTitle
    }
    
}

// MARK: - Configure

extension DetailCategoryChipCVC {
    
    /// 카테고리 세부 바텀시트에 표시되는 세부 장소 카테고리 셀 초기화시 사용
    func configureDetailPlaceCategoryChipCVC(detailCategoryTitle: String) {
        self.detailCategoryTitle = detailCategoryTitle
        placeCategoryButton.configureButton(with: detailCategoryTitle, for: .primary)
    }
    
}
