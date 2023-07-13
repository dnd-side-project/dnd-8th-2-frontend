//
//  MyPageVM.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/16.
//

import RxSwift
import RxCocoa
import RxDataSources

final class MyPageVM: BaseViewModel {
    
    // MARK: - Variables and Properties
    
    var input: Input = Input()
    var output: Output = Output()
    
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    struct Input {}
    
    struct Output {
        let accessToken = BehaviorRelay(value: KeychainManager.shared.read(for: .accessToken))
        var isAuthenticated: Observable<Bool> {
            accessToken.map { $0 != nil }
        }
        
        var userInfomation: BehaviorRelay<UserInfomation> = BehaviorRelay(value: UserInfomation.getUserInfo())
        
        private var mypageMenu: Observable<Array<MyPageMenu>> {
            isAuthenticated.map {
                $0 ? MyPageMenu.authenticated : MyPageMenu.unAuthenticated
            }
        }
        var mypageMenuDataSources: Observable<Array<MyPageMenuDataSource>> {
            mypageMenu.map {
                [
                    MyPageMenuDataSource(items: $0)
                ]
            }
        }
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

extension MyPageVM {
    func bindInput() {}
}

// MARK: - Output

extension MyPageVM {
    func bindOutput() {}
}

// MARK: - Networking

extension MyPageVM {
    
    /// 릿플 서버에게 로그아웃을 요청
    func requestLogout(completion: @escaping (Bool) -> Void) {
        let path = "/api/auth/logout"
        let resource = URLResource<EmptyEntity>(path: path)
        
        apiSession.reqeustPost(urlResource: resource, param: nil)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success:
                    KeychainManager.shared.removeAllKeys()
                    completion(true)
                case .failure(let error):
                    owner.apiError.onNext(error)
                    completion(false)
                }
            })
            .disposed(by: bag)
    }
    
}
