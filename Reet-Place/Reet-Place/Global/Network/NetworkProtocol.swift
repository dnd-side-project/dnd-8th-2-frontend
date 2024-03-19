//
//  NetworkProtocol.swift
//  Reet-Place
//
//  Created by 김태현 on 3/18/24.
//

import RxSwift

protocol NetworkProtocol {
    func request<R: Decodable, E: EndPointProtocol>(with endPoint: E) -> Observable<Result<R, APIError>> where R == E.Response
    func judgeError(statusCode: Int) -> APIError
}
