//
//  CoreDataEntityList.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/10/22.
//

import UIKit

// MARK: - CoreData Entity List

/// Core Data ReetPlace Persistent Container에 정의되어 있는 Entity 목록
enum CoreDataEntityList: String {
    case categoryFilter
    case searchHistory
}

extension CoreDataEntityList {
    var name: String {
        switch self {
        case .categoryFilter:
            return "CategoryFilter"
        case .searchHistory:
            return "SearchHistory"
        }
    }
}
