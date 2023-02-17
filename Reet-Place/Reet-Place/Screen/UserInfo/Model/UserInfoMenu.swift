//
//  UserInfoMenu.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/17.
//

import UIKit

enum UserInfoMenu: String {
    case sns = "ConnectSNS"
    case delete = "DeleteAccount"
}

// MARK: - CustomStringConvertible

extension UserInfoMenu: CustomStringConvertible {
    var description: String {
        rawValue.localized
    }
}

// MARK: - ForegroundColorProvider

extension UserInfoMenu: ForegroundColorProvider {
    var foregroundColor: UIColor? {
        switch self {
        case .sns:
            return AssetColors.black
        case .delete:
            return AssetColors.error
        }
    }
}

// MARK: - CaseIterable

extension UserInfoMenu: CaseIterable {}
