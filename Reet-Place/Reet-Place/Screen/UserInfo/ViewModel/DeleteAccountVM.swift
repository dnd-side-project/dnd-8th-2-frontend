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
    
    struct Output {
        var recordDelete: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        var lowUsed: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        var useOtherService: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        var inconvenience: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        var contentComplaint: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        var other: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        
        var deleteEnabled:Observable<Bool> {
            return Observable
                .combineLatest(recordDelete.asObservable(),
                               lowUsed.asObservable(),
                               useOtherService.asObservable(),
                               inconvenience.asObservable(),
                               contentComplaint.asObservable(),
                               other.asObservable())
                .map { recordDelete, lowUsed, useOtherService, inconvenience, contentComplaint, other in
                    return recordDelete || lowUsed || useOtherService || inconvenience || contentComplaint || other
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
