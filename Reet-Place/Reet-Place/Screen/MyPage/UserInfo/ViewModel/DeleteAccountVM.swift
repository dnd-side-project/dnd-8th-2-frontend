//
//  DeleteAccountVM.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/04/26.
//

import RxSwift
import RxCocoa

final class DeleteAccountVM {
    
    // MARK: - Variables and Properties
    
    var input = Input()
    var output = Output()
    
    let network: NetworkProtocol = NetworkProvider()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    struct Input {
        var otherDescription: BehaviorRelay<String?> = BehaviorRelay(value: nil)
        var selectedSurveyTypeList: BehaviorRelay<[DeleteAccountSurveyType]> = BehaviorRelay(value: [])
    }
    
    struct Output {
        var deleteEnabled = BehaviorRelay<Bool>(value: false)
        var isUnlinkSuccess = PublishRelay<Bool>()
        var loginType = PublishRelay<LoginType>()
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
    func bindInput() {
        input.selectedSurveyTypeList
            .withUnretained(self)
            .subscribe(onNext: { owner, selectedTypeList in
                owner.output.deleteEnabled.accept(!selectedTypeList.isEmpty)
            })
            .disposed(by: bag)
    }
}


// MARK: - Output

extension DeleteAccountVM: Output {
    func bindOutput() { }
}


// MARK: - Networking

extension DeleteAccountVM {
    
    /// 회원탈퇴 요청
    /// - Parameter identifier: 카카오 회원 - Access Token / 애플 회원 - Authorization Code
    func requestDeleteAccount(identifier: String) {
        let path = "/api/auth/unlink"
        let deleteAccountReason = createDeleteAccountRequestModel()
        var endPoint = EndPoint<EmptyEntity>(path: path,
                                             httpMethod: .post,
                                             body: deleteAccountReason)
        endPoint.addHeader(name: "identifier", value: identifier)
        
        network.request(with: endPoint)
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
                    owner.output.isUnlinkSuccess.accept(false)
                }
            })
            .disposed(by: bag)
    }
    
}


// MARK: - Custom Method

extension DeleteAccountVM {
    
    /// 회원탈퇴를 진행하기 위해 로그인 타입을 확인
    func checkLoginTypeForUnlink() {
        guard let loginTypeString = KeychainManager.shared.read(for: .loginType),
              let loginType = LoginType(rawValue: loginTypeString) else {
            output.isUnlinkSuccess.accept(false)
            return
        }
        
        output.loginType.accept(loginType)
    }
    
    /// 탈퇴 사유 선택
    /// - Parameter type: 선택한 사유 type
    func selectDeleteAccountType(_ type: DeleteAccountSurveyType) {
        var reason = input.selectedSurveyTypeList.value
        reason.append(type)
        input.selectedSurveyTypeList.accept(reason)
    }
    
    /// 탈퇴 사유 선택 해제
    /// - Parameter type: 선택 해제한 사유 type
    func deselectDeleteAccountType(_ type: DeleteAccountSurveyType) {
        var reason = input.selectedSurveyTypeList.value
        reason = reason.filter { $0 != type }
        input.selectedSurveyTypeList.accept(reason)
    }
    
    /// 선택된 surveyType들에 따라 DeleteAccountRequestModel 생성
    private func createDeleteAccountRequestModel() -> DeleteAccountRequestModel {
        let selectedSurveyTypeList = input.selectedSurveyTypeList.value
        var deleteAccountModelList: [DeleteAccountModel] = []
        
        selectedSurveyTypeList.forEach { type in
            if type == .other {
                let description = input.otherDescription.value ?? type.rawValue
                deleteAccountModelList.append(.init(surveyType: type.rawValue, description: description))
            } else {
                deleteAccountModelList.append(.init(surveyType: type.rawValue, description: type.rawValue))
            }
        }
        
        return DeleteAccountRequestModel(data: deleteAccountModelList)
    }
    
}
