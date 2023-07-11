//
//  LoginVM.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/04.
//

import RxCocoa
import RxSwift

import Alamofire

final class LoginVM: BaseViewModel {
    
    // MARK: - Variables and Properties
    
    var input = Input()
    var output = Output()
    
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    struct Input {}
    struct Output {
        var loading = BehaviorRelay<Bool>(value: false)
        
        var isLoginSucess = PublishRelay<Bool>()
    }
    
    // MARK: - Life Cycle
    
    init() {
        bindInput()
        bindOutput()
    }
    
    deinit {
        bag = DisposeBag()
    }
}

// MARK: - Input

extension LoginVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension LoginVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension LoginVM {
    
    func requestSocialLogin(socialType: LoginType, token: String, nickname: String = .empty) {
        let path = "/api/auth/login/\(socialType.description)\(socialType.headerQuery)\(nickname)"
        let resource = URLResource<LoginResponseModel>(path: path)
        
        requestSocialLogin(urlResource: resource, socialType: socialType, token: token)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .failure(let error):
                    owner.apiError.onNext(error)
                    owner.output.isLoginSucess.accept(false)
                case .success(let data):
                    KeychainManager.shared.save(key: .appleUserAuthID, value: data.uid)
                    KeychainManager.shared.save(key: .accessToken, value: data.accessToken)
                    KeychainManager.shared.save(key: .refreshToken, value: data.refreshToken)
                    KeychainManager.shared.save(key: .userName, value: data.nickname)
                    KeychainManager.shared.save(key: .memberID, value: String(data.memberID))
                    KeychainManager.shared.save(key: .loginType, value: data.loginType.lowercased())
                    
                    owner.output.isLoginSucess.accept(true)
            }
        })
        .disposed(by: bag)
    }
    
    func requestSocialLogin<T: Decodable>(urlResource: URLResource<T>, socialType: LoginType, token: String) -> Observable<Result<T, APIError>> {
        Observable<Result<T, APIError>>.create { observer in
            let headers: HTTPHeaders = [
                "Accept": "*/*",
                "\(socialType.headerParamter)": token
            ]
            
            let task = AF.request(urlResource.resultURL,
                                  method: .post,
                                  encoding: JSONEncoding.default,
                                  headers: headers)
                .validate(statusCode: 200...399)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .failure(let error):
                        dump(error)
                        guard let error = response.response else { return }
                        observer.onNext(urlResource.judgeError(statusCode: error.statusCode))
                        
                    case .success(let data):
                        observer.onNext(.success(data))
                    }
                }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
}
