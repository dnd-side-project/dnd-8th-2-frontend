//
//  CategoryDetailShoppingList.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/05/13.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

enum CategoryDetailShoppingList: String {
    case departmentStore = "백화점"
    case mart = "마트"
    case market = "시장"
}

// MARK: - Case Iterable

extension CategoryDetailShoppingList: CaseIterable {}

// MARK: - Custom String Convertible

extension CategoryDetailShoppingList: CustomStringConvertible {
    var description: String {
        rawValue.localized
    }
}
