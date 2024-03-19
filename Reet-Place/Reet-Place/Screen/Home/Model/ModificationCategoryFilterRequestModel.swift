//
//  ModificationCategoryFilterRequestModel.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/12/05.
//

import Foundation

// MARK: - ModificationCategoryFilter RequestModel

struct ModificationCategoryFilterRequestModel: Encodable {
    let contents: [PlaceCategoryModel]
}
