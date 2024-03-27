//
//  BookmarkTypeInfo.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/04/16.
//

import Foundation

struct BookmarkTypeInfo {
    let type: String
    let cnt: Int
    let thumbnailUrlString: String
}

extension BookmarkTypeInfo {
    static let empty: Self = .init(type: .empty,
                                   cnt: 0,
                                   thumbnailUrlString: .empty)
}
