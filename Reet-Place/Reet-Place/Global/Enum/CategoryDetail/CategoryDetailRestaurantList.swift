//
//  CategoryDetailRestaurantList.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/06/14.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

/// 식당
enum CategoryDetailRestaurantList: String {
    case koreanFood = "한식"
    case chineseFood = "중식"
    case japaneseFood = "일식"
    case westernFood = "양식"
    case worldesternFood = "세계 음식"
}

// MARK: - Case Iterable

extension CategoryDetailRestaurantList: CaseIterable {}

// MARK: - Custom String Convertible

extension CategoryDetailRestaurantList: CustomStringConvertible {
    var description: String {
        rawValue.localized
    }
}

// MARK: - Network

extension CategoryDetailRestaurantList {
    var parameterCategory: String {
        switch self {
        case .koreanFood:
            return "KOREAN"
        case .chineseFood:
            return "CHINESE"
        case .japaneseFood:
            return "JAPANESE"
        case .westernFood:
            return "WESTERN"
        case .worldesternFood:
            return "WORLD"
        }
    }
}
