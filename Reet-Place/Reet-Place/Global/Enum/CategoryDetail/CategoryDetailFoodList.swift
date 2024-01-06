//
//  CategoryDetailFoodList.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/05/13.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

/// 식도락
enum CategoryDetailFoodList: String {
    case restaurant = "식당"
    case bar = "주점"
}

// MARK: - Case Iterable

extension CategoryDetailFoodList: CaseIterable {}

// MARK: - Custom String Convertible

extension CategoryDetailFoodList: CustomStringConvertible {
    var description: String {
        rawValue.localized
    }
}

// MARK: - 음식 하위 항목

extension CategoryDetailFoodList {
    var categoryDetailList: [String] {
        switch self {
        case .restaurant:
            return CategoryDetailRestaurantList.allCases.map { $0.rawValue }
        case .bar:
            return CategoryDetailBarList.allCases.map { $0.rawValue }
        }
    }
}

// MARK: - Network

extension CategoryDetailFoodList {
    var parameterCategory: [String] {
        switch self {
        case .restaurant:
            return CategoryDetailRestaurantList.allCases.map { $0.parameterCategory }
        case .bar:
            return CategoryDetailBarList.allCases.map { $0.parameterCategory }
        }
    }
}
