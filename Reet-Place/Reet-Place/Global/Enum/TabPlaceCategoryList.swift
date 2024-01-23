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
}

// MARK: - Case Iterable

extension TabPlaceCategoryList: CaseIterable {}

// MARK: - Custom String Convertible

extension TabPlaceCategoryList: CustomStringConvertible {
    var description: String {
        rawValue.localized
    }
}

// MARK: - Category Detail

extension TabPlaceCategoryList {
    var categoryDetailList: [String] {
        switch self {
        case .food:
            return CategoryDetailRestaurantList.allCases.map { $0.rawValue }
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
            return CategoryDetailRestaurantList.allCases.map { $0.parameterCategory }
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
    
    // TODO: - 카테고리별 검색기록 더미 데이터 삭제
    var list: [String] {
        switch self {
        case .all:
            return ["꾸꾸루꾸 치킨", "CGV 강남점", "반올림 피자샵", "어글리 베이커리", "시현하다 프레임", "인생다섯컷", "숏컷", "입구컷", "더현대", "판교현백", "행복한 백화점", "용산 메가박스"]
        case .food:
            return ["꾸꾸루꾸 치킨", "반올림 피자샵"]
        case .activity:
            return []
        case .photoBooth:
            return ["시현하다 프레임", "인생다섯컷", "숏컷", "입구컷"]
        case .shopping:
            return ["더현대", "판교현백", "행복한 백화점"]
        case .cafe:
            return ["어글리 베이커리"]
        case .culture:
            return ["용산 메가박스", "CGV 강남점"]
        }
    }
}
