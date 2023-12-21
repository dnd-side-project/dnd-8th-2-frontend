//
//  SearchPlaceListResponseModel.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/13.
//

import Foundation

// MARK: - SearchPlaceList ResponseModel

struct SearchPlaceListResponseModel: Codable {
    let contents: [SearchPlaceListContent]
}

// MARK: - SearchPlaceListContent

struct SearchPlaceListContent: Codable {
    let kakaoPID, name: String
    let url: String
    let kakaoCategoryName, category, subCategory: String
    let categoryGroupCode: String?
    let phone, lotNumberAddress, roadAddress, lat, lng: String
    let type: String?
    let bookmarkID: Int?

    enum CodingKeys: String, CodingKey {
        case kakaoPID = "kakaoPid"
        case name, url, categoryGroupCode, kakaoCategoryName, category, subCategory, phone, lotNumberAddress, roadAddress, lat, lng, type
        case bookmarkID = "bookmarkId"
    }
}

extension SearchPlaceListContent {
    func toBookmarkSavePlace() -> BookmarkSavePlaceModel {
        return .init(
            kakaoPlaceId: kakaoPID,
            name: name,
            url: url,
            kakaoCategoryName: kakaoCategoryName,
            categoryGroupCode: categoryGroupCode,
            category: category,
            subCategory: subCategory,
            phone: phone,
            lotNumberAddress: lotNumberAddress,
            roadAddress: roadAddress,
            lat: lat,
            lng: lng
        )
    }
}
