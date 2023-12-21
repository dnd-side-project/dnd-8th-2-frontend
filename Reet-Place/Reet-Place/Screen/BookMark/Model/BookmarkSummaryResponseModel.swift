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
    let rate: Int
    let people: String?
    let relLink1: String?
    let relLink2: String?
    let relLink3: String?
    
    func toSummary() -> BookmarkSummaryModel {
        return .init(
            id: id,
            thumbnailImage: thumbnailImage,
            type: type,
            name: place.name,
            url: place.url,
            category: place.category,
            subCategory: place.subCategory,
            lotNumberAddress: place.lotNumberAddress,
            roadAddress: place.roadAddress,
            lat: Double(place.lat) ?? 0.0,
            lng: Double(place.lng) ?? 0.0,
            rate: rate,
            people: people,
            relLink1: relLink1,
            relLink2: relLink2,
            relLink3: relLink3
        )
    }
}
