//
//  SearchPlaceKeywordRequestModel.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/10/29.
//

import Foundation

// MARK: - SearchPlaceKeyword RequestModel

struct SearchPlaceKeywordRequestModel: Codable {
    let lat, lng: Double
    let query: String
    let page: Int
}
