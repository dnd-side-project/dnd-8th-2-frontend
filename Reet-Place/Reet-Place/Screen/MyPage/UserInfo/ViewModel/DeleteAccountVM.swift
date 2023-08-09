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
        var recordDelete: Observable<Bool> {
            selectedSurveyType.map { $0 == .recordDelete }
        }
        
        var lowUsed: Observable<Bool> {
            selectedSurveyType.map { $0 == .lowUsed }
        }
        
        var useOtherService: Observable<Bool> {
            selectedSurveyType.map { $0 == .useOtherService }
        }
        
        var inconvenience: Observable<Bool> {
            selectedSurveyType.map { $0 == .inconvenienceAndErrors }
        }
        
        var contentComplaint: Observable<Bool> {
            selectedSurveyType.map { $0 == .contentDissatisfaction }
        }
        
        var other: Observable<Bool> {
            selectedSurveyType.map { $0 == .other }
        }
        
        var otherDescription: BehaviorRelay<String?> = BehaviorRelay(value: nil)
        
        var selectedSurveyType: BehaviorRelay<DeleteAccountSurveyType?> = BehaviorRelay(value: nil)
        
        var deleteEnabled: Observable<Bool> {
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
    func requestDeleteAccount() {
        let path = "/api/auth/unlink"
        let resource = URLResource<EmptyEntity>(path: path)
        let deleteAccountReason = createDeleteAccountRequestModel()
        
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


// MARK: - Custom Method

extension DeleteAccountVM {
    
    func createDeleteAccountRequestModel() -> DeleteAccountRequestModel {
        guard let surveyType = output.selectedSurveyType.value else { fatalError() }
        
        if surveyType == .other {
            return DeleteAccountRequestModel(surveyType: surveyType, description: output.otherDescription.value ?? "")
        } else {
            return DeleteAccountRequestModel(surveyType: surveyType, description: surveyType.description)
        }
    }
    
}
