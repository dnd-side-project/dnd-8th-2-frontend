//
//  TabPlaceCategoryList.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/05/03.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

enum TabPlaceCategoryList: String {
    case all = "전체"
    case food = "식도락"
    case activity = "액티비티"
    case photoBooth = "포토부스"
    case shopping = "쇼핑"
    case cafe = "카페"
    case culture = "문화생활"
    
    init(rawValue: String) {
        switch rawValue {
        case "ALL":
            self = .all
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
            self = .all
        }
    }
}

// MARK: - Case Iterable

extension TabPlaceCategoryList: CaseIterable {}

// MARK: - Custom String Convertible

extension TabPlaceCategoryList: CustomStringConvertible {
    var description: String {
        rawValue.localized
    }
}

// MARK: - Place Network

extension TabPlaceCategoryList {
    var parameterCategory: String {
        switch self {
        case .all:
            return "ALL"
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
}

// MARK: - Category Detail

extension TabPlaceCategoryList {
    var categoryDetailList: [String] {
        switch self {
        case .food:
            return CategoryDetailFoodList.allCases
                .map { $0.categoryDetailList }
                .flatMap { $0 }
        case .activity:
            return CategoryDetailActivityList.allCases.map { $0.rawValue }
        case .photoBooth:
            return CategoryDetailPhotoBoothList.allCases.map { $0.rawValue }
        case .shopping:
            return CategoryDetailShoppingList.allCases.map { $0.rawValue }
        case .cafe:
            return CategoryDetailCafeList.allCases.map { $0.rawValue }
        case .culture:
            return CategoryDetailCultureList.allCases.map { $0.rawValue }
        default:
            return []
        }
    }
    
    var categoryDetailParameterList: [String] {
        switch self {
        case .food:
            return CategoryDetailFoodList.allCases
                .map { $0.parameterCategory }
                .flatMap { $0 }
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
        default:
            return []
        }
    }
}
