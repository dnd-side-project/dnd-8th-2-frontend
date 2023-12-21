//
//  BookmarkListResponseModel.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/08/20.
//

import Foundation

struct BookmarkListResponseModel: Codable {
    let size: Int
    let content: [BookmarkInfo]
    let number: Int
    let sort: SortInfo
    let numberOfElements: Int
    let pageable: PageableInfo
    let first: Bool
    let last: Bool
    let empty: Bool
}

struct BookmarkInfo: Codable {
    let id: Int
    let member: BookmarkUserInfo
    let place: BookmarkPlaceInfo
    let type: String
    let thumbnailImage: String?
    let rate: Int
    let people: String?
    let relLink1: String?
    let relLink2: String?
    let relLink3: String?
    
    func toBookmarkCardModel() -> BookmarkCardModel {
        return .init(id: id,
                     thumbnailImage: thumbnailImage,
                     placeName: place.name,
                     categoryName: place.category,
                     starCount: rate,
                     address: place.roadAddress,
                     groupType: type,
                     withPeople: people,
                     relLink1: relLink1,
                     relLink2: relLink2,
                     relLink3: relLink3)
    }
}

struct BookmarkUserInfo: Codable {
    let id: Int
    let uid: String
    let loginType: String
    let nickname: String
}

struct BookmarkPlaceInfo: Codable {
    let id: Int
    let kakaoPid: String
    let name: String
    let url: String
    let categoryGroupCode: String
    let kakaoCategoryName: String
    let category: String
    let subCategory: String
    let lotNumberAddress: String
    let roadAddress: String
    let lat: String
    let lng: String
}

struct SortInfo: Codable {
    let empty: Bool
    let unsorted: Bool
    let sorted: Bool
}

struct PageableInfo: Codable {
    let offset: Int
    let sort: SortInfo
    let pageSize: Int
    let paged: Bool
    let pageNumber: Int
    let unpaged: Bool
}
