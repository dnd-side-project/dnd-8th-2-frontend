//
//  BookmarkSummaryModel.swift
//  Reet-Place
//
//  Created by 김태현 on 12/19/23.
//

import Foundation

struct BookmarkSummaryModel {
    let id: Int
    let thumbnailImage: String?
    let type: String
    let name: String
    let url: String
    let category: String
    let subCategory: String
    let lotNumberAddress: String
    let roadAddress: String
    let lat: Double
    let lng: Double
    let rate: Int
    let people: String?
    let relLink1: String?
    let relLink2: String?
    let relLink3: String?
    
    func toBookmarkCardModel() -> BookmarkCardModel {
        return .init(
            id: id,
            thumbnailImage: thumbnailImage,
            placeName: name,
            placeDetailURL: url,
            categoryName: category,
            starCount: rate,
            address: roadAddress,
            groupType: type,
            withPeople: people,
            relLink1: relLink1,
            relLink2: relLink2,
            relLink3: relLink3
        )
    }
}
