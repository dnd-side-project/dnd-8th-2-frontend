//
//  MyPageViewModel.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/16.
//

import Foundation

import RxSwift
import RxCocoa

final class MyPageViewModel: BaseViewModel {
    var input: Input = Input()
    
    var output: Output = Output()
    
    var apiSession: APIService = APISession()
    
    var bag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        let authToken = BehaviorRelay(value: KeychainManager.shared.read(for: .authToken))
        
        var isValidAuthToken: Observable<Bool> {
            // TODO: Auth token validation
            authToken.map { $0 != nil }
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
