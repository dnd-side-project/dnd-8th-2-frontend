//
//  LoginType.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/04.
//

import UIKit

enum LoginType: String {
    case kakao
    case apple
}

// MARK: - Custom String Convertible

extension LoginType: CustomStringConvertible {
    var description: String {
        rawValue.localized
    }
}

// MARK: - Login Button

extension LoginType {
    var logoImage: UIImage? {
        switch self {
        case .kakao:
            return AssetsImages.kakaoLoginLogo
        case .apple:
            return AssetsImages.appleLoginLogo
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
            return UIColor(red: 52.0/255.0, green: 31.0/255.0, blue: 32.0/255.0, alpha: 1.0)
        case .apple:
            return AssetColors.white
        }
    }
    
    var explainTextFont: UIFont {
        switch self {
        case .kakao,
            .apple:
            return AssetFonts.buttonSmall.font
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .kakao:
            return UIColor(red: 254.0/255.0, green: 229.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        case .apple:
            return AssetColors.black
        }
    }
    
    var accountProviderSNSIcon: UIImage? {
        switch self {
        case .kakao:
            return AssetsImages.kakaoLogo
        case .apple:
            return AssetsImages.appleLogo
        }
    }
}

// MARK: - Login Network

extension LoginType {
    var headerQuery: String {
        switch self {
        case .kakao:
            return .empty
        case .apple:
            return "?nickname="
        }
    }
    
    var headerParamter: String {
        switch self {
        case .kakao:
            return "access-token"
        case .apple:
            return "identity-token"
        }
    }
}
