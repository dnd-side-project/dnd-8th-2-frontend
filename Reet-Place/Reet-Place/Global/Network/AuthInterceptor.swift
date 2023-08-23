//
//  AuthInterceptor.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import RxSwift
import Alamofire

class AuthInterceptor: RequestInterceptor {
    
    // MARK: - Variables and Properties
    
    private let bag = DisposeBag()
    
    // MARK: - Functions
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        if let accessToken = KeychainManager.shared.read(for: .accessToken) {
            urlRequest.headers.add(.authorization(bearerToken: accessToken))
        }
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        // 토큰 만료 에러코드 401이 아닌 경우
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401
        else {
            // 시도하지 않고 종료
            completion(.doNotRetryWithError(error))
            return
        }
        
        APIToken.requestUpdateToken()
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(_):
                    print("토큰 갱신 성공")
                    completion(.retry)
                    
                case .failure(let error):
                    KeychainManager.shared.removeAllKeys()
                    
                    guard let rootVC = UIViewController.getRootViewController(),
                          let tabBarVC = rootVC.rootViewController as? ReetPlaceTabBarVC,
                          let myPageVC = tabBarVC.getTabInstance(tabType: .my)?.rootViewController as? MyPageVC
                    else {
                        completion(.doNotRetryWithError(error))
                        return
                    }
                    tabBarVC.showToast(message: "LogoutSuccess".localized, bottomViewHeight: 50.0)
                    myPageVC.updateLoginStatus()
                    
                    print("로그인 만료")
                    completion(.doNotRetryWithError(error))
                }
            })
            .disposed(by: bag)
    }
    
}
