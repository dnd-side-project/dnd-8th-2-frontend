//
//  SearchHistoryResponseModel.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/12/18.
//

import Foundation

// MARK: - SearchHistory ResponseModel

struct SearchHistoryResponseModel: Codable {
    let contents: [SearchHistoryContent]
}

// MARK: - SearchHistory Content

struct SearchHistoryContent: Codable {
    let id: Int
    let query, createdAt: String
}
