//
//  AccountProviderType.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/17.
//

import UIKit

/// 소셜 로그인 제공자 타입
enum AccountProviderType: String {
    case kakao
}

// MARK: - IconProvider

extension AccountProviderType: IconProvider {
    var iconImage: UIImage? {
        switch self {
        case .kakao:
            return AssetsImages.kakao
        }
    }
}
