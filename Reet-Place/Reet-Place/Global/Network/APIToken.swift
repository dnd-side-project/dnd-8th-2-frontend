//
//  APIToken.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/09.
//

import RxSwift
import Alamofire

struct APIToken {
    
    static func requestUpdateToken() -> Observable<Result<Bool, APIError>> {
        Observable<Result<Bool, APIError>>.create { observer in
            guard let refreshToken = KeychainManager.shared.read(for: .refreshToken)
            else {
                observer.onNext(.failure(.unable))
                return Disposables.create()
            }
            var headers = HTTPHeaders()
            headers.add(.accept("*/*"))
            headers.add(.authorization(bearerToken: refreshToken))
            
            let path = "/api/auth/refresh"
            let urlResource = URLResource<Bool>(path: path)
            
            let task = AF.request(urlResource.resultURL,
                                  method: .post,
                                  encoding: URLEncoding.default,
                                  headers: headers)
                .validate(statusCode: 200...399)
                .responseDecodable(of: UpdateTokenResponseModel.self) { response in
                    switch response.result {
                    case .success(let data):
                        KeychainManager.shared.updateToken(updatedToken: data)
                        observer.onNext(.success(true))
                        
                    case .failure(let error):
                        dump(error)
                        guard let error = response.response else { return }
                        observer.onNext(urlResource.judgeError(statusCode: error.statusCode))
                    }
                }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
}
