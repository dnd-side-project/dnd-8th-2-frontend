//
//  ReetTextFieldStyle.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/03/02.
//

import UIKit

enum ReetTextFieldStyle: String {
    case normal
    case active
    case disabled
    case error
}

extension ReetTextFieldStyle {
    
    var textColor: UIColor {
        switch self {
        case .normal,
                .active,
                .error:
            return AssetColors.black
        case .disabled:
            return AssetColors.gray500
        }
    }
    
    var placeholderColor: UIColor {
        switch self {
        case .normal,
                .active:
            return AssetColors.gray500
        case .disabled:
            return AssetColors.gray300
        case .error:
            return AssetColors.error
        }
    }
    
    var borderColor: CGColor {
        switch self {
        case .normal,
                .disabled:
            return AssetColors.gray300.cgColor
        case .active:
            return AssetColors.black.cgColor
        case .error:
            return AssetColors.error.cgColor
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .normal,
                .active,
                .error:
            return AssetColors.white
        case .disabled:
            return AssetColors.gray100
        }
    }
    
    var clearBtnColor: UIColor {
        switch self {
        case .normal,
                .active,
                .error:
            return AssetColors.gray500
        case .disabled:
            return AssetColors.gray300
        }
    }
}
