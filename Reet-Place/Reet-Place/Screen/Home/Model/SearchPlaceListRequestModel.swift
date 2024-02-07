//
//  SearchPlaceListRequestModel.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/13.
//

import Foundation
import Alamofire

// MARK: - SearchPlaceList RequestModel

struct SearchPlaceListRequestModel: Codable {
    let lat, lng, category: String
    var subCategory: [String]
}

// MARK: - Paramters

extension SearchPlaceListRequestModel {
    var parameter: Parameters {
        return [
            "lat": lat,
            "lng": lng,
            "category": category,
            "subCategory": subCategory
        ]
    }
}
