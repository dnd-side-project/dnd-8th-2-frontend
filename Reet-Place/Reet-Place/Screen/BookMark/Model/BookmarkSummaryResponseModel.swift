//
//  BookmarkSummaryResponseModel.swift
//  Reet-Place
//
//  Created by 김태현 on 12/19/23.
//

import Foundation

typealias BookmarkSummaryListResponseModel = [BookmarkSummaryResponseModel]

struct BookmarkSummaryResponseModel: Decodable {
    let id: Int
    let place: BookmarkPlaceInfo
    let type: String
    let thumbnailImage: String?
    
    func toSummary() -> BookmarkSummaryModel {
        return .init(
            id: id,
            type: type,
            name: place.name,
            url: place.url,
            category: place.category,
            subCategory: place.subCategory,
            lotNumberAddress: place.lotNumberAddress,
            roadAddress: place.roadAddress,
            lat: Double(place.lat) ?? 0.0,
            lng: Double(place.lng) ?? 0.0
        )
    }
}
