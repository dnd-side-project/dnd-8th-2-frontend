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
    
    // TODO: - qna 추가
    static let unAuthenticated = [
        MyPageMenu.servicePolicy,
        MyPageMenu.privacyPoilcy
    ]
    
    static let authenticated = [
        MyPageMenu.userInfo,
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


// MARK: - ViewController

extension MyPageMenu {
    func createVC() -> UIViewController {
        switch self {
        case .qna:
            return SubmitQnaVC()
        case .servicePolicy:
            return ServicePolicyVC()
        case .privacyPoilcy:
            return PrivacyPolicyVC()
        case .userInfo:
            return UserInfoVC()
        case .signout:
            return UIViewController()
        }
    }
}

// MARK: - URL

extension MyPageMenu {
    var url: URL? {
        switch self {
        case .servicePolicy:
            return URL(string: "https://wo-ogie.notion.site/fdbb5946fc7940a6a4cf8610431c1a25?pvs=4")
        case .privacyPoilcy:
            return URL(string: "https://wo-ogie.notion.site/5e9ca7c31738431089b5aeffd7423039?pvs=4")
        default:
            return nil
        }
    }
}
