//
//  ReetTextButtonStyle.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/04/20.
//

import UIKit

/// Reet TextButton 스타일 종류 정의
enum ReetTextButtonStyle {
    case primary
    case secondary
    case tertiary
}

extension ReetTextButtonStyle {
    
    var enabledTitleColor: UIColor {
        switch self {
        case .primary:
            return AssetColors.primary500
        case .secondary:
            return AssetColors.black
        case .tertiary:
            return AssetColors.gray500
        }
    }
    
    var pressedTitleColor: UIColor {
        switch self {
        case .primary:
            return AssetColors.primary600
        case .secondary:
            return AssetColors.gray700
        case .tertiary:
            return AssetColors.gray700
        }
    }
    
    var diabledTitleColor: UIColor {
        AssetColors.gray300
    }
    
}
