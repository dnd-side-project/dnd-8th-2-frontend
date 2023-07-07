//
//  LoginType.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/04.
//

import UIKit

enum LoginType {
    case kakao
    case apple
}

extension LoginType {
    var logoImage: UIImage? {
        switch self {
        case .kakao:
            return AssetsImages.kakao // TODO: - 카카오 로고 확인
        case .apple:
            return UIImage(systemName: "apple.logo")?.withTintColor(AssetColors.white, renderingMode: .alwaysOriginal)
        }
    }
    
    var logoImageSize: CGFloat {
        switch self {
        case .kakao:
            return 29.3
        case .apple:
            return 25.6
        }
    }
    
    var explainText: String {
        switch self {
        case .kakao:
            return "LoginKakao".localized
        case .apple:
            return "LoginApple".localized
        }
    }
    
    var explainTextColor: UIColor {
        switch self {
        case .kakao:
            return UIColor(red: 52, green: 31, blue: 32, alpha: 1.0) // TODO: - 카카오 색상 확인
        case .apple:
            return AssetColors.white
        }
    }
    
    var explainTextFont: UIFont {
        switch self {
        case .kakao
            , .apple:
            return AssetFonts.buttonSmall.font
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .kakao:
            return UIColor(red: 254, green: 229, blue: 0, alpha: 1.0) // TODO: - 카카오 색상 확인
        case .apple:
            return AssetColors.black
        }
    }
}
