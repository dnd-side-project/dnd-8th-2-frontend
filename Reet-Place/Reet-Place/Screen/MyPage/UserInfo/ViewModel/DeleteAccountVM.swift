//
//  DeleteAccountVM.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/04/26.
//

import RxSwift
import RxCocoa

final class DeleteAccountVM: BaseViewModel {
    
    // MARK: - Variables and Properties
    
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

extension DeleteAccountVM: Input {
    func bindInput() { }
}


// MARK: - Output

extension DeleteAccountVM: Output {
    func bindOutput() { }
}


// MARK: - Networking

extension DeleteAccountVM {
    
    /// 릿플 서버에게 회원탈퇴를 요청
    func requestDeleteAccount(deleteAccountReason: DeleteAccountRequestModel) {
        let path = "/api/auth/unlink"
        let resource = URLResource<EmptyEntity>(path: path)
        
        // TODO: - 탈퇴 서버연결 마무리
//        apiSession.reqeustPost(urlResource: resource, parameter: deleteAccountReason.parameter)
//            .withUnretained(self)
//            .subscribe(onNext: { owner, result in
//                switch result {
//                case .success:
//                    
//                case .failure(let error):
//                    owner.apiError.onNext(error)
//                }
//            })
//            .disposed(by: bag)
    }
    
}
