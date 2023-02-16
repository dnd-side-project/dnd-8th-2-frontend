//
//  MyPageMenu.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/16.
//

import UIKit

enum MyPageMenu: String {
    case qna = "DoQna"
    case servicePolicy = "ServicePolicy"
    case privacyPoilcy = "PrivacyPoilcy"
    case userInfo = "UserInfo"
    case signout = "Signout"
    
    static let unAuthenticated = [
        MyPageMenu.qna,
        MyPageMenu.servicePolicy,
        MyPageMenu.privacyPoilcy
    ]
    
    static let authenticated = [
        MyPageMenu.userInfo,
        MyPageMenu.qna,
        MyPageMenu.servicePolicy,
        MyPageMenu.privacyPoilcy,
        MyPageMenu.signout
    ]
}

// MARK: - ForegroundColorProvider

extension MyPageMenu: ForegroundColorProvider {
    var foregroundColor: UIColor? {
        switch self {
        case .qna:
            return AssetColors.black
        case .servicePolicy:
            return AssetColors.black
        case .privacyPoilcy:
            return AssetColors.black
        case .userInfo:
            return AssetColors.black
        case .signout:
            return AssetColors.error
        }
    }
}


// MARK: - CustomStringConvertible

extension MyPageMenu: CustomStringConvertible {
    var description: String {
        rawValue.localized
    }
}
