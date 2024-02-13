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
            return "북마크를 해제할까요?"
        case .withdrawal:
            return "정말 탈퇴하시겠어요?"
        case .goToLogin:
            return "로그인이 필요한 서비스에요!"
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
            return "북마크를 해제하시면,\n입력하셨던 내용이 전부 사라집니다."
        case .withdrawal:
            return "탈퇴 이후 당신의 장소들은\n다시 복구되지 않아요."
        case .goToLogin:
            return "로그인하고 장소들을 저장하고,\n나만의 지도를 채워보세요."
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
            return "해제"
        case .withdrawal:
            return "탈퇴"
        case .goToLogin:
            return "로그인하기"
        }
    }
    
}
