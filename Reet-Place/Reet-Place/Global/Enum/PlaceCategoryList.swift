//
//  PlaceCategoryList.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/26.
//

import UIKit

enum PlaceCategoryList: String {
    case reetPlaceHot
    case food
    case activity
    case photoBooth
    case shopping
    case cafe
    case culture
    
    init(rawValue: String) {
        switch rawValue {
        case "REET_PLACE_POPULAR":
            self = .reetPlaceHot
        case "FOOD":
            self = .food
        case "ACTIVITY":
            self = .activity
        case "PHOTO_BOOTH":
            self = .photoBooth
        case "SHOPPING":
            self = .shopping
        case "CAFE":
            self = .cafe
        case "CULTURE":
            self = .culture
        default:
            self = .reetPlaceHot
        }
    }
}

// MARK: - Case Iterable

extension PlaceCategoryList: CaseIterable {}

// MARK: - Custom String Convertible

extension PlaceCategoryList {
    var name: String {
        switch self {
        case .reetPlaceHot:
            return "👀 릿플 인기"
        case .food:
            return "식도락"
        case .activity:
            return "액티비티"
        case .photoBooth:
            return "포토부스"
        case .shopping:
            return "쇼핑"
        case .cafe:
            return "카페"
        case .culture:
            return "문화생활"
        }
    }
}

// MARK: - Place Network

extension PlaceCategoryList {
    var parameterPlace: String {
        switch self {
        case .reetPlaceHot:
            return "REET_PLACE_POPULAR"
        case .food:
            return "FOOD"
        case .activity:
            return "ACTIVITY"
        case .photoBooth:
            return "PHOTO_BOOTH"
        case .shopping:
            return "SHOPPING"
        case .cafe:
            return "CAFE"
        case .culture:
            return "CULTURE"
        }
    }
    
    var parameterSubCategoryList: [String] {
        switch self {
        case .reetPlaceHot:
            return ["REET_PLACE_POPULAR"]
        case .food:
            return CategoryDetailFoodList.allCases.flatMap { $0.parameterCategory.map { $0 } }
        case .activity:
            return CategoryDetailActivityList.allCases.map { $0.parameterCategory }
        case .photoBooth:
            return CategoryDetailPhotoBoothList.allCases.map { $0.parameterCategory }
        case .shopping:
            return CategoryDetailShoppingList.allCases.map { $0.parameterCategory }
        case .cafe:
            return CategoryDetailCafeList.allCases.map { $0.parameterCategory }
        case .culture:
            return CategoryDetailCultureList.allCases.map { $0.parameterCategory }
        }
    }
}
