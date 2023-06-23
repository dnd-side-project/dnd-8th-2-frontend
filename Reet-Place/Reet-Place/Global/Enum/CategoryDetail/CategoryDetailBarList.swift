//
//  CategoryDetailBarList.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/06/14.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

enum CategoryDetailBarList: String {
    // 주점
    case hofCookingBar = "호프, 요리주점"
    case izakaya = "이자카야"
    case cartBar = "포장마차"
    case wineBar = "와인바"
    case cocktailBar = "칵테일바"
}

// MARK: - Case Iterable

extension CategoryDetailBarList: CaseIterable {}

// MARK: - Custom String Convertible

extension CategoryDetailBarList: CustomStringConvertible {
    var description: String {
        rawValue.localized
    }
}
