//
//  SelectBoxStyle.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/06/26.
//

import UIKit

enum SelectBoxStyle: String {
    case defaultPlaceInfo
    case bookmarked
}

extension SelectBoxStyle {
    
    var selectTitle: [String] {
        switch self {
        case .defaultPlaceInfo:
            return ["북마크", "공유하기"]
        case .bookmarked:
            return ["북마크 수정", "링크복사", "북마크 삭제"]
        }
    }
    
    var numberOfRows: Int {
        selectTitle.count
    }
    
}
