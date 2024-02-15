//
//  PopUpType.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/05/01.
//

import UIKit

enum PopUpType {
    case deleteBookmark
    case withdrawal
    case goToLogin
}

extension PopUpType {
    var popUpTitle: String {
        switch self {
        case .deleteBookmark:
            return "DeleteBookmarkPopUpTitle".localized
        case .withdrawal:
            return "WithdrawalPopUpTitle".localized
        case .goToLogin:
            return "GoToLoginPopUpTitle".localized
        }
    }
    
    var popUpTitleFont: UIFont {
        switch self {
        case .deleteBookmark:
            return AssetFonts.h4.font
        case .withdrawal, .goToLogin:
            return AssetFonts.subtitle1.font
        }
    }
    
    var popUpDesc: String {
        switch self {
        case .deleteBookmark:
            return "DeleteBookmarkPopUpDesc".localized
        case .withdrawal:
            return "WithdrawalPopUpDesc".localized
        case .goToLogin:
            return "GoToLoginPopUpDesc".localized
        }
    }
    
    var popUpDescFont: UIFont {
        switch self {
        case .deleteBookmark:
            return AssetFonts.body2.font
        case .withdrawal, .goToLogin:
            return AssetFonts.body1.font
        }
    }
    
    var popUpDescColor: UIColor {
        switch self {
        case .deleteBookmark:
            return AssetColors.error
        case .withdrawal, .goToLogin:
            return AssetColors.black
        }
    }
    
    var popUpConfirmBtnTitle: String {
        switch self {
        case .deleteBookmark:
            return "DeleteBookmarkPopUpConfirmTitle".localized
        case .withdrawal:
            return "WithdrawalPopUpConfirmTitle".localized
        case .goToLogin:
            return "GoToLoginPopUpConfirmTitle".localized
        }
    }
    
}
