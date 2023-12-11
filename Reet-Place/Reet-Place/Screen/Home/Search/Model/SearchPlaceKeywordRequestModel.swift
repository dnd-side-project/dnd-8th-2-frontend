//
//  SearchPlaceKeywordRequestModel.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/10/29.
//

import Foundation
import Alamofire

// MARK: - SearchPlaceKeyword RequestModel

struct SearchPlaceKeywordRequestModel: Codable {
    let lat, lng: Double
    let placeKeword: String
    let page: Int
}

// MARK: - Paramters

extension SearchPlaceKeywordRequestModel {
    var parameter: Parameters {
        return [
            "lat": lat,
            "lng": lng,
            "query": placeKeword,
            "page": page
        ]
    }
}
