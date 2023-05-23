//
//  CategoryChipStyle.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/26.
//

import UIKit

/// Represents the style of chip button

enum CategoryChipStyle: String {
    case primary
    case secondary
}

extension CategoryChipStyle: CaseIterable {}

// MARK: - Title Color

extension CategoryChipStyle {
    var normalTitleColor: UIColor {
        AssetColors.black
    }
  
    var highlightedTitleColor: UIColor {
        AssetColors.black
    }
    
    var selectedTitleColor: UIColor {
        AssetColors.white
    }
    
    var disabledTitleColor: UIColor {
        AssetColors.gray300
    }
}

// MARK: - Background Color

extension CategoryChipStyle {
    var normalBackgroundColor: UIColor {
        AssetColors.white
    }
  
    var highlightedBackgroundColor: UIColor {
        AssetColors.gray100
    }
    
    var selectedBackgroundColor: UIColor {
        switch self {
        case .primary:
            return AssetColors.primary500
        case .secondary:
            return AssetColors.black
        }
    }
    
    var disabledBackgroundColor: UIColor {
        AssetColors.gray100
    }
}

// MARK: - Border Color

extension CategoryChipStyle {
    var normalBorderColor: UIColor {
        AssetColors.gray300
    }
  
    var highlightedBorderColor: UIColor {
        AssetColors.black
    }
    
    var selectedBorderColor: UIColor {
        .clear
    }
    
    var disabledBorderColor: UIColor {
        AssetColors.gray300
    }
}
