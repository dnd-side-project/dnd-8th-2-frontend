//
//  MyPageViewModel.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/16.
//

import Foundation

import RxSwift
import RxCocoa
import RxDataSources

final class MyPageViewModel: BaseViewModel {
    var input: Input = Input()
    
    var output: Output = Output()
    
    var apiSession: APIService = APISession()
    
    var bag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        private let authToken = BehaviorRelay(value: KeychainManager.shared.read(for: .authToken))
        
        var isAuthenticated: Observable<Bool> {
            // TODO: Auth token validation
            authToken.map { $0 == nil }
        }
        
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
        
        var user: BehaviorRelay<ModelUser?> = BehaviorRelay(value: ModelUser.mock())
    }
    
    init() {
        bindInput()
        bindOutput()
    }
    
    deinit {
        bag = DisposeBag()
    }
    
    func bindInput() {
        
    }
    
    func bindOutput() {
        
    }
    
}
