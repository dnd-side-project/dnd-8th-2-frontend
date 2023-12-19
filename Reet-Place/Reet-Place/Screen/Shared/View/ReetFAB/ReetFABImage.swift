//
//  ReetFABImage.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/03/02.
//

import UIKit

enum ReetFABImage {
    case map
    case filter
    case directionTool
    case goToTop
}

extension ReetFABImage {
    var image: UIImage {
        switch self {
        case .filter:
            return AssetsImages.filter16
        case .directionTool:
            return AssetsImages.directionTool20
        case .map:
            return AssetsImages.map20
        case .goToTop:
            return AssetsImages.goToTop
        }
    }
}
