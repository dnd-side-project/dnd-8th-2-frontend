//
//  SelectBoxStyle.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/06/26.
//

import UIKit

enum SelectBoxStyle: String {
    case bookmarked
    case notBookmarked
}

extension SelectBoxStyle {
    
    var selectTitle: [String] {
        switch self {
        case .bookmarked:
            return ["북마크 수정", "링크복사", "북마크 삭제"]
        case .notBookmarked:
            return ["북마크", "공유하기"]
        }
    }
    
    var numberOfRows: Int {
        switch self {
        case .bookmarked:
            return 3
        case .notBookmarked:
            return 2
        }
    }
    
}
