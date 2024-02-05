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

// MARK: - Paramters

extension ModificationCategoryFilterRequestModel {
    var parameter: Parameters {
        return [
            "contents": contents.map { $0.parameter }
        ]
    }
}
