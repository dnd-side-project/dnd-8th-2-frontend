//
//  LoginResponseModel.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/04.
//

import Foundation

// MARK: - Login ResponseModel

struct LoginResponseModel: Codable {
    let memberID: Int
    let uid, loginType, nickname, accessToken: String
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case uid, loginType, nickname, accessToken, refreshToken
    }
}
