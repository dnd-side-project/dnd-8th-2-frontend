//
//  ModelUser.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/17.
//

import Foundation

struct ModelUser: Codable {
    var id: Int
    var name: String?
    var email: String?
    var accountType: String?
    var thumbnailUrl: String?
}

extension ModelUser {
    var accountProviderType: AccountProviderType? {
        guard let accountType = accountType,
              let provider = AccountProviderType(rawValue: accountType) else { return nil }
        
        return provider
    }
    
    static func mock() -> ModelUser {
        return ModelUser(id: 1958273495,
                         name: "김아무개",
                         email: "aaron@aaron.aaron",
                         accountType: "kakao",
                         thumbnailUrl: "https://avatars.githubusercontent.com/u/63542621?v=4")
    }
}
