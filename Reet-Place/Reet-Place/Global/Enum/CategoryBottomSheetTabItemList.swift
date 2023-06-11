//
//  CategoryBottomSheetTabItemList.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/05/03.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

enum TabPlaceCategoryList: String {
    case food = "식도락"
    case activity = "액티비티"
    case photoBooth = "포토부스"
    case shopping = "쇼핑"
    case cafe = "카페"
    case culture = "문화생활"
}

// MARK: - Case Iterable

extension TabPlaceCategoryList: CaseIterable {}

// MARK: - Custom String Convertible

extension TabPlaceCategoryList: CustomStringConvertible {
    var description: String {
        rawValue.localized
    }
}

// MARK: - Functions

extension TabPlaceCategoryList {
    func createCategoryDetailView() -> CategoryDetailView {
        switch self {
        case .food:
            return CategoryDetailFoodView(tabCategory: .food)
        case .activity:
            return CategoryDetailActivityView(tabCategory: .activity)
        case .photoBooth:
            return CategoryDetailPhotoBoothView(tabCategory: .photoBooth)
        case .shopping:
            return CategoryDetailShoppingView(tabCategory: .shopping)
        case .cafe:
            return CategoryDetailCafeView(tabCategory: .cafe)
        case .culture:
            return CategoryDetailCultureView(tabCategory: .culture)
        }
    }
}
