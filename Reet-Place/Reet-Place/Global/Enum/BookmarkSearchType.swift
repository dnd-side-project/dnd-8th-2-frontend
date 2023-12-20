//
//  BookmarkSearchType.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/08/20.
//

import Foundation

enum BookmarkSearchType: String {
    case `all` = "ALL"
    case want = "WANT"
    case done = "DONE"
}

extension BookmarkSearchType {
    var title: String {
        switch self {
        case .all:
            return "BookmarkAll".localized
        case .want:
            return "BookmarkWishlist".localized
        case .done:
            return "BookmarkHistory".localized
        }
    }
}
