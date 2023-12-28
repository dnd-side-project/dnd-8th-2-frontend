//
//  BookmarkSaveRequestModel.swift
//  Reet-Place
//
//  Created by 김태현 on 12/20/23.
//

import Foundation

struct BookmarkSaveRequestModel: Encodable {
    let place: BookmarkSavePlaceModel
    let type: String
    let rate: Int
    let people: String?
    let relLink1: String?
    let relLink2: String?
    let relLink3: String?
}

struct BookmarkSavePlaceModel: Encodable {
    let kakaoPlaceId: String
    let name: String
    let url: String
    let kakaoCategoryName: String
    let categoryGroupCode: String?
    let category: String
    let subCategory: String
    let phone: String
    let lotNumberAddress: String
    let roadAddress: String
    let lat: String
    let lng: String
}
