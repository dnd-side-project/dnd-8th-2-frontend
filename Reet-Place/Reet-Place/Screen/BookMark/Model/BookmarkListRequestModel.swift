//
//  BookmarkListRequestModel.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/08/20.
//

import Foundation
import Alamofire

struct BookmarkListRequestModel {
    let searchType: BookmarkSearchType
    let page: Int
    let size: Int
    let sort: BookmarkSortType
}

extension BookmarkListRequestModel {
    var parameter: Parameters {
        return [
            "searchType": searchType.rawValue,
            "page": page,
            "size": size,
            "sort": sort.rawValue
        ]
    }
}
