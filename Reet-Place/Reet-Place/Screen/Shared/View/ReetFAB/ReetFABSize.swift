//
//  ReetFABSize.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/03/02.
//

import UIKit

/// Represents the style of FAB(Floating Action button)
enum ReetFABSize {
    case round(Size)
    case extended(Size)
    
    enum Size {
        case large
        case small
    }
}

extension ReetFABSize {
    var height: CGFloat {
        switch self {
        case .round(.large):
            return 56.0
        case .round(.small):
            return 44.0
        case .extended(.large):
            return 44.0
        case .extended(.small):
            return 32.0
        }
    }
    
    var horizontalOffset: CGFloat {
        switch self {
        case .round(.large):
            return 16.0
        case .round(.small):
            return 12.0
        case .extended(.large):
            return 16.0
        case .extended(.small):
            return 8.0
        }
    }
    
    var imageHeight: CGFloat {
        switch self {
        case .round(.large):
            return 24.0
        case .round(.small):
            return 20.0
        case .extended(.large):
            return 20.0
        case .extended(.small):
            return 16.0
        }
    }
    
    var image: CGFloat {
        switch self {
        case .round(.large):
            return 16.0
        case .round(.small):
            return 12.0
        case .extended(.large):
            return 16.0
        case .extended(.small):
            return 8.0
        }
    }
    
    var titleFont: AssetFonts {
        switch self {
        case .extended(.large):
            return .buttonLarge
        case .extended(.small):
            return .buttonSmall
        case .round:
            return .tooltip
        }
    }
    
    var titleSpacing: CGFloat {
        switch self {
        case .extended(.large):
            return 8.0
        case .extended(.small):
            return 6.0
        case .round:
            return 0.0
        }
    }
}
