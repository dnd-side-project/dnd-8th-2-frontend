//
//  LoginViewModel.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/16.
//

import Foundation

import RxSwift
import RxCocoa
import RxDataSources

final class LoginViewModel: BaseViewModel {
    var input: Input = Input()
    
    var output: Output = Output()
    
    var apiSession: APIService = APISession()
    
    var bag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        private var mypageMenu = BehaviorRelay(value: MyPageMenu.unAuthenticated)
        
        var mypageMenuDataSources: Observable<Array<MyPageMenuDataSource>> {
            mypageMenu.map {
                [
                    MyPageMenuDataSource(items: $0)
                ]
            }
        }
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