//
//  PlaceCategoryList.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/26.
//

import UIKit

enum PlaceCategoryList: String {
    case filter
    case reetPlaceHot = "👀 릿플 인기"
    case food = "식도락"
    case activity = "액티비티"
    case photoBooth = "포토부스"
    case shopping = "쇼핑"
    case cafe = "카페"
    case culture = "문화생활"
}

// MARK: - Case Iterable

extension PlaceCategoryList: CaseIterable {}

// MARK: - Custom String Convertible

extension PlaceCategoryList: CustomStringConvertible {
    var description: String {
        rawValue.localized
    }
}
