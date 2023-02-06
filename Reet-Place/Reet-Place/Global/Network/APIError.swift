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
        }
    }
}
