//
//  NetworkProvider.swift
//  Reet-Place
//
//  Created by 김태현 on 3/18/24.
//

import Alamofire
import RxSwift

struct NetworkProvider: NetworkProtocol {
    func request<R: Decodable, E: EndPointProtocol>(with endPoint: E) -> Observable<Result<R, APIError>> where R == E.Response {
        guard let requestURL = endPoint.requestURL else {
            return .create { observer in
                observer.onNext(.failure(.invalidURL))
                observer.onCompleted()
                return Disposables.create()
            }
        }
        
        if let body = endPoint.body {
            return request(requestURL, with: endPoint, body: body)
        }
        
        return .create { observer in
            let task = AF.request(requestURL,
                                  method: endPoint.httpMethod,
                                  encoding: JSONEncoding.default,
                                  headers: endPoint.headers,
                                  interceptor: AuthInterceptor())
                .validate(statusCode: 200...399)
                .responseDecodable(of: R.self) { response in
                    debugPrint(response)
                    switch response.result {
                    case .success(let data):
                        observer.onNext(.success(data))
                    case .failure(let error):
                        dump(error)
                        guard let error = response.response else {
                            return observer.onNext(.failure(.invalidResponse))
                        }
                        let apiError = judgeError(statusCode: error.statusCode)
                        observer.onNext(.failure(apiError))
                    }
                }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func judgeError(statusCode: Int) -> APIError {
        switch statusCode {
        case 400...409:
            return .decode
        case 500:
            return .http(status: statusCode)
        default:
            return .unknown(status: statusCode)
        }
    }
}


// MARK: - Private

private extension NetworkProvider {
    func request<R: Decodable, E: EndPointProtocol>(_ requestURL: URL,
                                                    with endPoint: E,
                                                    body: Encodable) -> Observable<Result<R, APIError>> {
        return .create { observer in
            let task = AF.request(requestURL,
                                  method: endPoint.httpMethod,
                                  parameters: body,
                                  encoder: JSONParameterEncoder.default,
                                  headers: endPoint.headers,
                                  interceptor: AuthInterceptor())
                .validate(statusCode: 200...399)
                .responseDecodable(of: R.self) { response in
                    debugPrint(response)
                    switch response.result {
                    case .success(let data):
                        observer.onNext(.success(data))
                    case .failure(let error):
                        dump(error)
                        guard let error = response.response else {
                            return observer.onNext(.failure(.invalidResponse))
                        }
                        let apiError = judgeError(statusCode: error.statusCode)
                        observer.onNext(.failure(apiError))
                    }
                }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
