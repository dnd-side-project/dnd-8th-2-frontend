//
//  LoginVM.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/04.
//

import RxCocoa
import RxSwift

import Alamofire

import KakaoSDKAuth
import KakaoSDKUser

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
    
    /// 소셜 로그인 요청 후 리스펀스 된 사용자 정보를 로컬 디바이스에 저장
    func requestSocialLogin(socialType: LoginType, token: String, nickname: String = .empty) {
        let path = "/api/auth/login/\(socialType.description)\(socialType.headerQuery)\(nickname)"
        let resource = URLResource<LoginResponseModel>(path: path)
        
        requestSocialLogin(urlResource: resource, socialType: socialType, token: token)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let data):
                    KeychainManager.shared.save(key: .appleUserAuthID, value: data.uid)
                    KeychainManager.shared.save(key: .accessToken, value: data.accessToken)
                    KeychainManager.shared.save(key: .refreshToken, value: data.refreshToken)
                    KeychainManager.shared.save(key: .userName, value: data.nickname)
                    KeychainManager.shared.save(key: .memberID, value: String(data.memberID))
                    KeychainManager.shared.save(key: .loginType, value: data.loginType.lowercased())
                    
                    print("\(socialType.description) 로그인 성공")
                    
                    owner.output.isLoginSucess.accept(true)
                    
                case .failure(let error):
                    owner.apiError.onNext(error)
                    owner.output.isLoginSucess.accept(false)
            }
        })
        .disposed(by: bag)
    }
    
    /// 소셜 로그인(카카오, 애플)을 요청
    func requestSocialLogin<T: Decodable>(urlResource: URLResource<T>, socialType: LoginType, token: String) -> Observable<Result<T, APIError>> {
        Observable<Result<T, APIError>>.create { observer in
            var headers = HTTPHeaders()
            headers.add(.accept("*/*"))
            headers.add(name: socialType.headerParamter, value: token)
            
            let task = AF.request(urlResource.resultURL,
                                  method: .post,
                                  encoding: JSONEncoding.default,
                                  headers: headers)
                .validate(statusCode: 200...399)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(.success(data))
                        
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

// MARK: - 카카오 로그인

extension LoginVM {
    
    /// '카카오 로그인' API 호출
    func requestKakaoLogin() {
        // 카카오톡 앱 실행 가능여부 확인
        switch UserApi.isKakaoTalkLoginAvailable() {
        case true:
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print(error)
                } else {
                    print("카카오톡 앱으로 로그인 성공")
                    self.requestKakaoLogin(oauthToken: oauthToken)
                }
            }
            
        case false:
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print(error)
                } else {
                    print("카카오 계정(웹)으로 로그인 성공")
                    self.requestKakaoLogin(oauthToken: oauthToken)
                }
            }
        }
    }
    
    private func requestKakaoLogin(oauthToken: OAuthToken?) {
        guard let responseKakaoOAuthToken = oauthToken
        else {
            print("Reponse Kakao OAuth Token Error - nil")
            return
        }
        requestSocialLogin(socialType: .kakao, token: responseKakaoOAuthToken.accessToken)
    }
    
}
