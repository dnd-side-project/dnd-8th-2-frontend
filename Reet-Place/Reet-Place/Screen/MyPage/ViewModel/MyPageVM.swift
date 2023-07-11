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
    
    var bag = DisposeBag()
    
    struct Input {}
    
    struct Output {
        let accessToken = BehaviorRelay(value: KeychainManager.shared.read(for: .accessToken))
        var isAuthenticated: Observable<Bool> {
            // TODO: Auth token validation
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
