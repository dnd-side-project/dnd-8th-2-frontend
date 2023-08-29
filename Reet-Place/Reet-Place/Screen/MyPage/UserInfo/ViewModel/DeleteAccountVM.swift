//
//  DeleteAccountVM.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/04/26.
//

import RxSwift
import RxCocoa

import Alamofire

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
        
        var isUnlinkSuccess = PublishRelay<Bool>()
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
    
    /// VC에서 회원탈퇴 요청
    func requestDeleteAccount() {
        let path = "/api/auth/unlink"
        let resource = URLResource<EmptyEntity>(path: path)
        let deleteAccountReason = createDeleteAccountRequestModel()
        guard let identifier = KeychainManager.shared.read(for: .identifier) else { return }
        
        requestUnlink(urlResource: resource, parameter: deleteAccountReason.parameter, identifier: identifier)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success:
                    print("탈퇴 성공")
                    KeychainManager.shared.removeAllKeys()
                    owner.output.isUnlinkSuccess.accept(true)
                case .failure(let error):
                    print("탈퇴 실패")
                    print(error)
                    owner.apiError.onNext(error)
                }
            })
            .disposed(by: bag)
    }
    
    /// 릿플 서버에 회원탈퇴 요청
    private func requestUnlink<T: Decodable>(urlResource: URLResource<T>, parameter: Parameters?, identifier: String) -> Observable<Result<T, APIError>> {
        Observable<Result<T, APIError>>.create { observer in
            var headers = HTTPHeaders()
            headers.add(.accept("*/*"))
            headers.add(.contentType("application/json"))
            headers.add(name: "identifier", value: identifier)
            
            let task = AF.request(urlResource.resultURL,
                                  method: .post,
                                  parameters: parameter,
                                  encoding: JSONEncoding.default,
                                  headers: headers,
                                  interceptor: AuthInterceptor())
                .validate(statusCode: 200...399)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(.success(data))
                        
                    case .failure(let error):
                        dump(error)
                        guard let error = response.response else { return }
                        observer.onNext(urlResource.judgeError(statusCode: error.statusCode))
                    }
                }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
}


// MARK: - Custom Method

extension DeleteAccountVM {
    
    /// surveyType에 따라 DeleteAccountRequestModel 생성
    private func createDeleteAccountRequestModel() -> DeleteAccountRequestModel {
        guard let surveyType = output.selectedSurveyType.value else { fatalError() }
        
        if surveyType == .other {
            return DeleteAccountRequestModel(surveyType: surveyType,
                                             description: output.otherDescription.value ?? .empty)
        } else {
            return DeleteAccountRequestModel(surveyType: surveyType,
                                             description: surveyType.description)
        }
    }
    
}
