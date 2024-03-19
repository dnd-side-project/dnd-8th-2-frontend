//
//  EndPointProtocol.swift
//  Reet-Place
//
//  Created by 김태현 on 3/18/24.
//

import Alamofire

protocol EndPointProtocol {
    associatedtype Response
    
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var body: Encodable? { get }
    var headers: HTTPHeaders { get set }
}

extension EndPointProtocol {
    var baseURLString: String {
        return "https://reet-place.shop"
    }
    
    var requestURL: URL? {
        return URL(string: baseURLString + path)
    }
    
    mutating func addHeader(name: String, value: String) {
        headers.add(name: name, value: value)
    }
}
