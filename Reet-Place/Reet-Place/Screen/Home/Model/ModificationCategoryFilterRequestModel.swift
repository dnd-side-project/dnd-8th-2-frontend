//
//  ModificationCategoryFilterRequestModel.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/12/05.
//

import Foundation
import Alamofire

// MARK: - ModificationCategoryFilter RequestModel

struct ModificationCategoryFilterRequestModel: Codable {
    let contents: [PlaceCategoryModel]
}

// MARK: - PlaceCategory Model

struct PlaceCategoryModel: Codable {
    var category: String
    var subCategory: [String]
}

// MARK: - Paramters

extension ModificationCategoryFilterRequestModel {
    var parameter: Parameters {
        return [
            "contents": contents
        ]
    }
}
