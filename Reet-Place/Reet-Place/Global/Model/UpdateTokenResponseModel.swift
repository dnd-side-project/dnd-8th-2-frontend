//
//  UpdateTokenResponseModel.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/09.
//

import Foundation

// MARK: - UpdateToken ResponseModel

struct UpdateTokenResponseModel: Codable {
    let accessToken, refreshToken: String
}

