//
//  BookmarkModifyRequestModel.swift
//  Reet-Place
//
//  Created by 김태현 on 12/3/23.
//

import Foundation

struct BookmarkModifyRequestModel: Encodable {
    let type: String
    let rate: Int
    let people: String?
    let relLink1: String?
    let relLink2: String?
    let relLink3: String?
}
