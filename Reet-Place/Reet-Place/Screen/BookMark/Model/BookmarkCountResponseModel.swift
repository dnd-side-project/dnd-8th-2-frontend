//
//  BookmarkCountResponseModel.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/08/20.
//

import Foundation

struct BookmarkCountResponseModel: Codable {
    let numberOfAll: Int
    let numberOfWant: Int
    let numberOfDone: Int
}
