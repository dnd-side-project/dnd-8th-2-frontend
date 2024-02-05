//
//  PlaceCategoryModel.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/12/05.
//

import Foundation
import Alamofire

// MARK: - PlaceCategory Model

struct PlaceCategoryModel: Codable {
    var category: String
    var subCategory: [String]
}

// MARK: - Paramters

extension PlaceCategoryModel {
    var parameter: Parameters {
        return [
            "category": category,
            "subCategory": subCategory
        ]
    }
}
