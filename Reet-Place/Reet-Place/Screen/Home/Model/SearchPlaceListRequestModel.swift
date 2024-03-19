//
//  SearchPlaceListRequestModel.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/13.
//

import Foundation

struct SearchPlaceListRequestModel: Encodable {
    let lat, lng, category: String
    var subCategory: [String]
}
