//
//  APIError.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

enum APIError: Error {
    case decode
    case http(status: Int)
    case unknown(status: Int)
    case unable
    case invalidURL
    case invalidResponse
}

extension APIError: CustomStringConvertible {
    var description: String {
        switch self {
        case .decode:
            return "Decode Error"
        case let .http(status):
            return "HTTP Error: \(status)"
        case let .unknown(status):
            return "Unknown Error: \(status)"
        case .unable:
            return "Use API Unable"
        case .invalidURL:
            return "Invalid request URL Error"
        case .invalidResponse:
            return "Invalid response Error"
        }
    }
}
