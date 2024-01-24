//
//  DeleteAccountVC.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/04/24.
//

import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import AuthenticationServices
import KakaoSDKAuth

final class DeleteAccountVC: BaseNavigationViewController {
    
    // MARK: - UI components
    
    private let descStackView = UIStackView()
        .then {
            $0.spacing = 12.0
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .vertical
        }
    
    private let confirmTitle = BaseAttributedLabel(font: .subtitle1,
                                                   text: "DeleteConfirmTitle".localized,
                                                   alignment: .left,
                                                   color: AssetColors.primary500)
    
    private let confirmDescView = UIView()
        .then {
            $0.backgroundColor = AssetColors.primary50
        }
    
    private let confirmDesc = BaseAttributedLabel(font: .body2,
                                                  text: "DeleteConfirmDesc".localized,
                                                  alignment: .center,
                                                  color: AssetColors.gray700)
        .then {
            $0.numberOfLines = .zero
        }
    
    private let checkTitle = BaseAttributedLabel(font: .subtitle1,
                                                 text: "DeleteCheckTitle".localized,
                                                 alignment: .left,
                                                 color: AssetColors.black)
    
    private let checkDesc = BaseAttributedLabel(font: .body2,
                                                text: "DeleteCheckDesc".localized,
                                                alignment: .left,
                                                color: AssetColors.gray500)
    
    private let checkboxStackView = UIStackView()
        .then {
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .vertical
        }
    
    private let recordDeleteBtn = CheckboxButton(with: "RecordDeleteBtn".localized)
    private let lowUsedBtn = CheckboxButton(with: "LowUsedBtn".localized)
    private let useOtherServiceBtn = CheckboxButton(with: "UseOtherServiceBtn".localized)
    private let inconvenienceBtn = CheckboxButton(with: "InconvenienceBtn".localized)
    private let contentComplaintBtn = CheckboxButton(with: "ContentComplaintBtn".localized)
    private let otherReasonBtn = CheckboxButton(with: "OtherBtn".localized)
    
    private let otherTextField = ReetTextField(style: .normal,
                                               placeholderString: "OtherTextPlaceHolder".localized,
                                               textString: .empty)
        .then {
            $0.isHidden = true
        }
    
    private let deleteBtn = ReetButton(with: "DeleteAccount".localized,
                                       for: .outlined)
    
    private let popUp = ReetPopUp()
    
    
    // MARK: - Variables and Properties
    
    private let viewModel: DeleteAccountVM = DeleteAccountVM()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureView() {
        super.configureView()
        
        configureNaviBar()
        configureDeleteAccount()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindRx() {
        super.bindRx()
        
        bindKeyboard()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindBtn()
        bindCheckbox()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        bindDeleteBtnEnabled()
        bindOtherReasonBtn()
        bindUnlinkResult()
        bindLoginType()
    }
    
    // MARK: - Functions
    
    @objc private func deleteAccount() {
        viewModel.input.otherDescription.accept(otherTextField.text)
        viewModel.checkLoginTypeForUnlink()
    }
    
    /// 애플 Revoke를 위한 Authorization Code 재발급
    private func requestAppleLoginForAuthorizationCode() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        authorizationController.performRequests()
    }
    
    /// 카카오 연결 해제를 위한 Access Token 재발급
    private func refreshKakaoToken() {
        AuthApi.shared.refreshToken { [weak self] newOauthToken, error in
            if let newOauthToken = newOauthToken {
                self?.viewModel.requestDeleteAccount(identifier: newOauthToken.accessToken)
            } else if let error = error {
                self?.showErrorAlert(error.localizedDescription)
            }
        }
    }
}


// MARK: - Configure

extension DeleteAccountVC {
    
    private func configureNaviBar() {
        navigationBar.style = .left
        title = "DeleteAccountTitle".localized
    }
    
    private func configureDeleteAccount() {
        view.addSubviews([descStackView, checkboxStackView, deleteBtn])
        
        [confirmTitle, confirmDescView, checkTitle, checkDesc].forEach {
            descStackView.addArrangedSubview($0)
        }
        
        confirmDescView.addSubview(confirmDesc)
        
        [recordDeleteBtn, lowUsedBtn, useOtherServiceBtn, inconvenienceBtn, contentComplaintBtn, otherReasonBtn, otherTextField].forEach {
            checkboxStackView.addArrangedSubview($0)
        }
    }
    
}


// MARK: - Layout

extension DeleteAccountVC {
    
    private func configureLayout() {
        descStackView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(16.0)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20.0)
            $0.height.equalTo(200.0)
        }
        
        descStackView.setCustomSpacing(24.0, after: confirmDescView)
        descStackView.setCustomSpacing(4.0, after: checkTitle)
        
        confirmTitle.snp.makeConstraints {
            $0.height.equalTo(24.0)
        }
        
        confirmDesc.snp.makeConstraints {
            $0.center.equalTo(confirmDescView.snp.center)
            $0.height.equalTo(42.0)
        }
        
        checkTitle.snp.makeConstraints {
            $0.height.equalTo(24.0)
        }
        
        checkDesc.snp.makeConstraints {
            $0.height.equalTo(21.0)
        }
        
        checkboxStackView.snp.makeConstraints {
            $0.top.equalTo(descStackView.snp.bottom).offset(12.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        [recordDeleteBtn, lowUsedBtn, useOtherServiceBtn, inconvenienceBtn, contentComplaintBtn, otherReasonBtn, otherTextField].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(40.0)
            }
        }
        
        deleteBtn.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20.0)
        }
    }
    
}


// MARK: - Input

extension DeleteAccountVC {
    
    private func bindBtn() {
        deleteBtn.rx.tap
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.showPopUp(popUpType: .withdrawal, 
                                targetVC: owner,
                                confirmBtnAction: #selector(owner.deleteAccount))
            })
            .disposed(by: bag)
    }
    
    private func bindCheckbox() {
        typealias ButtonType = (button: CheckboxButton, surveyType: DeleteAccountSurveyType)
        let buttonList: [ButtonType] = [(recordDeleteBtn, .recordDelete),
                                        (lowUsedBtn, .lowUsed),
                                        (useOtherServiceBtn, .useOtherService),
                                        (inconvenienceBtn, .inconvenienceAndErrors),
                                        (contentComplaintBtn, .contentDissatisfaction),
                                        (otherReasonBtn, .other)]
        
        buttonList.forEach { type in
            type.button.rx.tap
                .withUnretained(self)
                .bind(onNext: { owner, _ in
                    if type.button.isSelected {
                        owner.viewModel.selectDeleteAccountType(type.surveyType)
                    } else {
                        owner.viewModel.deselectDeleteAccountType(type.surveyType)
                    }
                })
                .disposed(by: bag)
        }
    }
    
}


// MARK: - Output

extension DeleteAccountVC {
    
    private func bindDeleteBtnEnabled() {
        viewModel.output.deleteEnabled
            .withUnretained(self)
            .bind(onNext: { owner, deleteEnabled in
                DispatchQueue.main.async {
                    owner.deleteBtn.isEnabled = deleteEnabled
                }
            })
            .disposed(by: bag)
    }
    
    private func bindOtherReasonBtn() {
        otherReasonBtn.isSelectedSubject
            .withUnretained(self)
            .subscribe { owner, isSelected in
                owner.otherTextField.isHidden = !isSelected
            }
            .disposed(by: bag)
    }
    
    private func bindUnlinkResult() {
        viewModel.output.isUnlinkSuccess
            .withUnretained(self)
            .bind(onNext: { owner, isSuccess in
                if isSuccess {
                    let accountDeletedVC = AccountDeletedVC()
                    
                    accountDeletedVC.modalPresentationStyle = .overFullScreen
                    owner.present(accountDeletedVC, animated: false)
                } else {
                    owner.showToast(message: "UnlinkFailed".localized)
                }
            })
            .disposed(by: bag)
    }
    
    private func bindLoginType() {
        viewModel.output.loginType
            .withUnretained(self)
            .bind(onNext: { owner, loginType in
                switch loginType {
                case .apple:
                    owner.requestAppleLoginForAuthorizationCode()
                case .kakao:
                    owner.refreshKakaoToken()
                }
            })
            .disposed(by: bag)
    }
}


// MARK: - Bind

extension DeleteAccountVC {
    
    private func bindKeyboard() {
        // 키보드가 올라갈 때
        keyboardWillShow
            .compactMap { $0.userInfo }
            .map { userInfo -> CGFloat in
                return (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
            }
            .subscribe(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }

                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardHeight - 200
                }
                self.view.layoutIfNeeded()
            })
            .disposed(by: bag)
        
        // 키보드가 내려갈 때
        keyboardWillHide
            .compactMap { $0.userInfo }
            .map { userInfo -> CGFloat in
                return (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
            }
            .subscribe(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }
                self.view.frame.origin.y += keyboardHeight - 200
                self.view.layoutIfNeeded()
            })
            .disposed(by: bag)
    }
}

// MARK: - ASAuthorizationController Delegate

extension DeleteAccountVC: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let authorizationCode = appleIDCredential.authorizationCode,
              let parsedAuthorizationCode = String(data: authorizationCode, encoding: .utf8) else { return }
        
        viewModel.requestDeleteAccount(identifier: parsedAuthorizationCode)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        showErrorAlert("LoginAppleFailMessage".localized)
    }
    
}
