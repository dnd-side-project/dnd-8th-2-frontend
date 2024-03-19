//
//  UserInfoVM.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/17.
//

import Foundation

import RxSwift
import RxCocoa

final class UserInfoVM: BaseViewModel {
    
    // MARK: - Variables and Properties
    
    var bag: DisposeBag = DisposeBag()
    
    let apiError = PublishSubject<APIError>()
    
    var input: Input = Input()
    var output: Output = Output()
    
    struct Input {}
    
    struct Output {
        private var menu: BehaviorRelay<Array<UserInfoMenu>> = BehaviorRelay(value: UserInfoMenu.allCases)
        var userInformation: BehaviorRelay<UserInfomation> = BehaviorRelay(value: UserInfomation.getUserInfo())
        
        var menuDataSource: Observable<Array<UserInfoMenuDataSource>> {
            menu.map { [UserInfoMenuDataSource(items: $0)] }
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

extension UserInfoVM {
    func bindInput() {}
}

// MARK: - Output

extension UserInfoVM {
    func bindOutput() {}
}

// MARK: - Networking

extension UserInfoVM {
    
}
