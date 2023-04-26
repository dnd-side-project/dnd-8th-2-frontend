//
//  DeleteAccountVM.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/04/26.
//

import RxSwift
import RxCocoa

final class DeleteAccountVM: BaseViewModel {
    
    var input = Input()
    var output = Output()
    
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    struct Input { }
    
    struct Output { }
    
    init() {
        
    }
    
    deinit {
        
    }
}

// MARK: - Input

extension DeleteAccountVM: Input {
    func bindInput() { }
}


// MARK: - Output

extension DeleteAccountVM: Output {
    func bindOutput() { }
}


// MARK: - Networking

extension DeleteAccountVM {
    
}
