//
//  SearchPlaceKeywordResponseModel.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/09/02.
//

import Foundation

// MARK: - SearchPlaceKeyword ResponseModel

struct SearchPlaceKeywordResponseModel: Codable {
    let contents: [SearchPlaceKeywordListContent]
    let lastPage: Bool
}

// MARK: - SearchPlaceListContent

struct SearchPlaceKeywordListContent: Codable {
    let kakaoPID, name, url: String
    let thumbnailImage: String?
    let categoryGroupCode, kakaoCategoryName, category, subCategory: String
    let phone, lotNumberAddress, roadAddress: String
    let lng, lat: String
    let type: String?
    let bookmarkID, rate: Int?
    
    enum CodingKeys: String, CodingKey {
        case kakaoPID = "kakaoPid"
        case name, url, thumbnailImage, categoryGroupCode, kakaoCategoryName, category, subCategory, phone, lotNumberAddress, roadAddress, lat, lng, type
        case bookmarkID = "bookmarkId"
        case rate
    }
}
