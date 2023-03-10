//
//  PlaceCategoryList.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/26.
//

import UIKit

enum PlaceCategoryList: String {
    case filter
    case reetPlaceHot = "๐ ๋ฆฟํ ์ธ๊ธฐ"
    case food = "์๋๋ฝ"
    case activity = "์กํฐ๋นํฐ"
    case photoBooth = "ํฌํ ๋ถ์ค"
    case shopping = "์ผํ"
    case cafe = "์นดํ"
    case culture = "๋ฌธํ์ํ"
}

// MARK: - Case Iterable

extension PlaceCategoryList: CaseIterable {}

// MARK: - Custom String Convertible

extension PlaceCategoryList: CustomStringConvertible {
    var description: String {
        rawValue.localized
    }
}
