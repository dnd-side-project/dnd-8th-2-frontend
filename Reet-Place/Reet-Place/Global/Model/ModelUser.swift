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
    var thumbnailUrl: String?
}

extension ModelUser {
    static func mock() -> ModelUser {
        return ModelUser(id: 1958273495,
                         name: "김아무개",
                         thumbnailUrl: "https://avatars.githubusercontent.com/u/63542621?v=4")
    }
}
