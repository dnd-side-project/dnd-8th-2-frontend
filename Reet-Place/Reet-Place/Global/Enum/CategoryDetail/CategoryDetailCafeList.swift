//
//  CategoryDetailCafeList.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/05/13.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

enum CategoryDetailCafeList: String {
    case bookCafe = "북카페"
    case comicBookCafe = "만화카페"
    case dessertCafe = "디저트 카페"
    case cafe = "일반 카페"
    case fruitShop = "생과일전문점"
}

// MARK: - Case Iterable

extension CategoryDetailCafeList: CaseIterable {}

// MARK: - Custom String Convertible

extension CategoryDetailCafeList: CustomStringConvertible {
    var description: String {
        rawValue.localized
    }
}

// MARK: - Network

extension CategoryDetailCafeList {
    var parameterCategory: String {
        switch self {
        case .bookCafe:
            return "BOOK"
        case .comicBookCafe:
            return "CARTOON"
        case .dessertCafe:
            return "DESERT"
        case .cafe:
            return "CAFE"
        case .fruitShop:
            return "FRESH_FRUIT"
        }
    }
}
