//
//  BookmarkCardModel.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/18.
//

import Foundation

struct BookmarkCardModel {
    let id: Int
    let thumbnailImage: String
    let placeName: String
    let categoryName: String
    let starCount: Int
    let address: String
    let groupType: String
    let withPeople: String?
    let relLink1: String?
    let relLink2: String?
    let relLink3: String?
    
    var infoHidden: Bool = true
}
