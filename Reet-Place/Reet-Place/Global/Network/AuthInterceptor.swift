//
//  AuthInterceptor.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import Alamofire
import RxSwift

class AuthInterceptor: RequestInterceptor {
    
    // MARK: - Variables and Properties
    
    let bag = DisposeBag()
    
    // MARK: - Functions
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let accessToken = UserDefaults.standard.string(forKey: UserDefaults.Keys.accessToken) else { return }
        
        var urlRequest = urlRequest
        urlRequest.headers.add(.authorization(accessToken))
        completion(.success(urlRequest))
    }
    
}
