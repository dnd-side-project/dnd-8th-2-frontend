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

final class LoginVM {
    
    // MARK: - Variables and Properties
    
    var input = Input()
    var output = Output()
    
    let network: NetworkProtocol = NetworkProvider()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    struct Input {}
    struct Output {
        var loading = BehaviorRelay<Bool>(value: false)
        
        var isLoginSuccess = PublishRelay<Bool>()
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
    func requestSocialLogin(socialType: LoginType,
                            token: String,
                            nickname: String = .empty) {
        let path = "/api/auth/login/\(socialType.description)\(socialType.headerQuery)\(nickname)"
        var endPoint = EndPoint<LoginResponseModel>(path: path, httpMethod: .post)
        endPoint.addHeader(name: socialType.headerParamter, value: token)
        
        network.request(with: endPoint)
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
                    
                    owner.output.isLoginSuccess.accept(true)
                    
                case .failure(let error):
                    owner.apiError.onNext(error)
                    owner.output.isLoginSuccess.accept(false)
            }
        })
        .disposed(by: bag)
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
