//
//  BookmarkMainModel.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/04/16.
//

import Foundation

struct BookmarkMainModel {
    let bookmarkMainInfo: [TypeCnt]
}

struct TypeCnt {
    let type: String
    let cnt: Int
    let thumbnailUrlString: String
}

extension BookmarkMainModel {
    
    static func getMock(_ completion: @escaping(BookmarkMainModel) -> Void) {
        completion(BookmarkMainModel(bookmarkMainInfo: [
            TypeCnt(type: "WANT",
                    cnt: 8,
                    thumbnailUrlString: "https://picsum.photos/600/300"),
            TypeCnt(type: "GONE",
                    cnt: 4,
                    thumbnailUrlString: "https://picsum.photos/600/300")])
        )
    }
    
}
