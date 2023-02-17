//
//  UserInfoViewModel.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/17.
//

import Foundation

import RxSwift
import RxCocoa

final class UserInfoViewModel: BaseViewModel {
    var bag: DisposeBag = DisposeBag()
    
    var apiSession: APIService = APISession()
    
    var input: Input = Input()
    
    var output: Output = Output()
    
    struct Input {}
    
    struct Output {
        private var menu: BehaviorRelay<Array<UserInfoMenu>> = BehaviorRelay(value: UserInfoMenu.allCases)
        var user: BehaviorRelay<ModelUser?> = BehaviorRelay(value: nil)
        
        var menuDataSource: Observable<Array<UserInfoMenuDataSource>> {
            menu.map { [UserInfoMenuDataSource(items: $0)] }
        }
        
        var email: String? {
            user.value?.email
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
