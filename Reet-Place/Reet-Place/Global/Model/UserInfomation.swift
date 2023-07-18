//
//  UserInfomation.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/09.
//

import Foundation

struct UserInfomation {
    var id: String
    var name: String
    var email: String
    var loginType: String
    var thumbnailUrl: String?
}

extension UserInfomation {
    static func getUserInfo() -> UserInfomation {
        return UserInfomation(id: KeychainManager.shared.read(for: .memberID) ?? "-",
                              name: KeychainManager.shared.read(for: .userName) ?? "알 수 없는 사용자",
                              email: KeychainManager.shared.read(for: .email) ?? "Email Address Not Found",
                              loginType: KeychainManager.shared.read(for: .loginType) ?? .empty,
                              thumbnailUrl: nil)
    }
}
