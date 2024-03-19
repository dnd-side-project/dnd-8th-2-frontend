//
//  EndPoint.swift
//  Reet-Place
//
//  Created by 김태현 on 3/15/24.
//

import Alamofire

struct EndPoint<R: Decodable>: EndPointProtocol {
    typealias Response = R
    
    var path: String
    var httpMethod: HTTPMethod
    var body: Encodable?
    var headers: HTTPHeaders

    init(path: String,
         httpMethod: HTTPMethod,
         body: Encodable? = nil,
         headers: HTTPHeaders) {
        self.path = path
        self.httpMethod = httpMethod
        self.body = body
        self.headers = headers
    }
    
    init(path: String,
         httpMethod: HTTPMethod,
         body: Encodable? = nil) {
        self.path = path
        self.httpMethod = httpMethod
        self.body = body
        
        var headers = HTTPHeaders()
        headers.add(.accept("*/*"))
        headers.add(.contentType("application/json"))
        self.headers = headers
    }
}
