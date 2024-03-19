//
//  BookmarkCountResponseModel.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/08/20.
//

import Foundation

struct BookmarkCountResponseModel: Decodable {
    let numOfAll: Int
    let numOfWant: Int
    let numOfDone: Int
}
