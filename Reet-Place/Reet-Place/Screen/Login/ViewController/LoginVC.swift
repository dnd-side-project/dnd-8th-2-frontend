//
//  LoginVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/04.
//

import UIKit

import RxSwift
import RxCocoa

import Then
import SnapKit

import AuthenticationServices

protocol LoginAction {
    func loginSuccess()
}

class LoginVC: BaseViewController {
    
    // MARK: - UI components
    
    private let titleStackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 24.0
        }
    private let titleLabel = BaseAttributedLabel(font: .body2, text: "ReetPlaceTitleExplain".localized, alignment: .center, color: AssetColors.gray500)
    private let titleImageView = UIImageView(image: AssetsImages.reetPlaceTitle)
    
    private let loginTypeStackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 16.0
        }
    private let loginAppleButton = LoginButton(type: .apple)
    private let loginLaterButton = UIButton()
        .then {
            $0.titleLabel?.font = AssetFonts.caption.font
            $0.setTitleColor(AssetColors.gray500, for: .normal)
            $0.setTitle("LoginLater".localized, for: .normal)
        }
    
    // MARK: - Variables and Properties
    
    private let viewModel = LoginVM()
    var delegateLogin: LoginAction?
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindButton()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        bindLoginResponse()
    }
    
    // MARK: - Functions
    
    private func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

// MARK: - Configure

extension LoginVC {
    
}

// MARK: - Layout

extension LoginVC {
    
    private func configureLayout() {
        // Add Subviews
        view.addSubviews([titleStackView,
                         loginTypeStackView])
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleImageView)
        
        loginTypeStackView.addArrangedSubview(loginAppleButton)
        loginTypeStackView.addArrangedSubview(loginLaterButton)
        
        // Make Constraints
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(view).offset(156.0)
            $0.centerX.equalTo(view)
        }
        
        loginTypeStackView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view).inset(20.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16.0)
        }
        loginLaterButton.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(96.0)
            $0.height.equalTo(38.0)
        }
    }
    
}

// MARK: - Input

extension LoginVC {
    
    private func bindButton() {
        loginAppleButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.handleAuthorizationAppleIDButtonPress()
            })
            .disposed(by: bag)
        
        loginLaterButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.dismissVC()
            })
            .disposed(by: bag)
    }
    
}

// MARK: - Output

extension LoginVC {
    
    private func bindLoginResponse() {
        viewModel.output.isLoginSucess
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isLoginSucess in
                guard let self = self else { return }
                
                if isLoginSucess {
                    self.delegateLogin?.loginSuccess()
                    self.dismissVC()
                } else {
                    self.showErrorAlert("LoginFailMessage".localized)
                }
            })
            .disposed(by: bag)
    }
    
}

// MARK: - ASAuthorizationController Delegate

extension LoginVC: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            guard let identityToken = appleIDCredential.identityToken,
                  let parsedIdentityToken = String(data: identityToken, encoding: .utf8) else { return }
            let fullName = appleIDCredential.fullName ?? PersonNameComponents()
            let familyName = fullName.familyName ?? .empty
            let givenName = fullName.givenName ?? .empty
            
            if let email = appleIDCredential.email {
                KeychainManager.shared.save(key: .email, value: email)
            }
            
            viewModel.requestSocialLogin(socialType: .apple, token: parsedIdentityToken, nickname: familyName + givenName)
            
        case let passwordCredential as ASPasswordCredential:
        
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                print(("username: ", username, "password: ", password))
            }
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        showErrorAlert("LoginAppleFailMessage".localized)
    }
    
}

// MARK: - ASAuthorizationController PresentationContextProviding

extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
}

