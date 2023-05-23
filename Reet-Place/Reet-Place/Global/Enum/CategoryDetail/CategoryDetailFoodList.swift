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

enum CategoryDetailFoodList: String {
    // 식당
    case koreanFood = "한식"
    case chineseFood = "중식"
    case japaneseFood = "일식"
    case westernFood = "양식"
    case worldesternFood = "세계 음식"
    
    // 주점
    case hofCookingBar = "호프, 요리주점"
    case izakaya = "이자카야"
    case cartBar = "포장마차"
    case wineBar = "와인바"
    case cocktailBar = "칵테일바"
}

// MARK: - Case Iterable

extension CategoryDetailFoodList: CaseIterable {}

// MARK: - Custom String Convertible

extension CategoryDetailFoodList: CustomStringConvertible {
    var description: String {
        rawValue.localized
    }
}
