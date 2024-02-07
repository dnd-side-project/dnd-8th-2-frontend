//
//  BookmarkType.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/19.
//

import UIKit

/// Represents the type of Reet-Place Bookmark type
enum BookmarkType: String {
    case standard // 기본(nil일 때) 값
    case want // 가보고 싶어요
    case gone // 다녀왔어요
    
    init(rawValue: String) {
        switch rawValue {
        case "WANT":
            self = .want
        case "GONE":
            self = .gone
        default:
            self = .standard
        }
    }
}

extension BookmarkType {
    var markerState: MarkerType.State {
        switch self {
        case .standard:
            return .standard
        case .want:
            return .wishlist
        case .gone:
            return .didVisit
        }
    }
}
