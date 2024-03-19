//
//  PlaceCategoryModel.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/12/05.
//

import Foundation

// MARK: - PlaceCategory Model

struct PlaceCategoryModel: Encodable {
    var category: String
    var subCategory: [String]
}
