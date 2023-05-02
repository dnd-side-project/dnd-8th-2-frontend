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

class DeleteAccountVC: BaseNavigationViewController {
    
    // MARK: - UI components
    
    private let descStackView = UIStackView()
        .then {
            $0.spacing = 12.0
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .vertical
        }
    
    private let confirmTitle = BaseAttributedLabel(font: .subtitle1,
                                           text: "탈퇴 신청 전 확인해주세요.",
                                           alignment: .left,
                                           color: AssetColors.primary500)
    
    private let confirmDescView = UIView()
        .then {
            $0.backgroundColor = AssetColors.primary50
        }
    
    private let confirmDesc = BaseAttributedLabel(font: .body2,
                                          text: "탈퇴 이후 회원 정보 및 이용기록은 모두 삭제되며,\n당신의 멋진 지도는 다시 복구할 수 없어요.",
                                          alignment: .center,
                                          color: AssetColors.gray700)
        .then {
            $0.numberOfLines = .zero
        }
    
    private let checkTitle = BaseAttributedLabel(font: .subtitle1,
                                        text: "떠나시는 이유가 무엇인가요?",
                                        alignment: .left,
                                        color: AssetColors.black)
    
    private let checkDesc = BaseAttributedLabel(font: .body2,
                                        text: "더 나은 서비스 개선 목적의 자료로 사용할게요.",
                                        alignment: .left,
                                        color: AssetColors.gray500)
    
    private let checkboxStackView = UIStackView()
        .then {
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .vertical
        }
    
    private let recordDeleteBtn = CheckboxButton(with: "기록 삭제 목적")
    private let lowUsedBtn = CheckboxButton(with: "사용 빈도가 낮아서")
    private let useOtherServiceBtn = CheckboxButton(with: "다른 서비스 사용 목적")
    private let inconvenienceBtn = CheckboxButton(with: "이용이 불편하고 장애가 많아서")
    private let contentComplaintBtn = CheckboxButton(with: "콘텐츠 불만")
    private let otherBtn = CheckboxButton(with: "기타")
    
    private let otherTextField = ReetTextField(style: .normal,
                                       placeholderString: "기타 의견을 입력해주세요.*",
                                       textString: nil)
        .then {
            $0.isHidden = true
        }
    
    private let deleteBtn = ReetButton(with: "탈퇴하기",
                               for: .outlined)
    
    private let popUp = ReetPopUp()
    
    
    // MARK: - Variables and Properties
    
    let viewModel: DeleteAccountVM = DeleteAccountVM()
    
    
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
    }
    
    // MARK: - Functions
    
    @objc func deleteAccount() {
        print("TODO: - Withdrawal API to be call")
        guard let popUpVC = presentedViewController else { return }
        
        popUpVC.dismiss(animated: false) {
            let accountDeletedVC = AccountDeletedVC()
            
            accountDeletedVC.modalPresentationStyle = .overFullScreen
            self.present(accountDeletedVC, animated: false)
        }
        
    }
    
}


// MARK: - Configure

extension DeleteAccountVC {
    
    private func configureNaviBar() {
        navigationBar.style = .left
        title = "탈퇴하기"
    }
    
    private func configureDeleteAccount() {
        view.addSubviews([descStackView, checkboxStackView, deleteBtn])
        
        [confirmTitle, confirmDescView, checkTitle, checkDesc].forEach {
            descStackView.addArrangedSubview($0)
        }
        
        confirmDescView.addSubview(confirmDesc)
        
        [recordDeleteBtn, lowUsedBtn, useOtherServiceBtn, inconvenienceBtn, contentComplaintBtn, otherBtn, otherTextField].forEach {
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
        
        [recordDeleteBtn, lowUsedBtn, useOtherServiceBtn, inconvenienceBtn, contentComplaintBtn, otherBtn, otherTextField].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(40)
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
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.showPopUp(popUpType: .withdrawal, targetVC: self, confirmBtnAction: #selector(self.deleteAccount))
            })
            .disposed(by: bag)
    }
    
    private func bindCheckbox() {
        recordDeleteBtn.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.viewModel.output.recordDelete
                    .accept(self.recordDeleteBtn.isSelected)
            })
            .disposed(by: bag)
        
        lowUsedBtn.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.viewModel.output.lowUsed
                    .accept(self.lowUsedBtn.isSelected)
            })
            .disposed(by: bag)
        
        useOtherServiceBtn.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.viewModel.output.useOtherService
                    .accept(self.useOtherServiceBtn.isSelected)
            })
            .disposed(by: bag)
        
        inconvenienceBtn.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.viewModel.output.inconvenience
                    .accept(self.inconvenienceBtn.isSelected)
            })
            .disposed(by: bag)
        
        contentComplaintBtn.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.viewModel.output.contentComplaint
                    .accept(self.contentComplaintBtn.isSelected)
            })
            .disposed(by: bag)
        
        otherBtn.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.viewModel.output.other
                    .accept(self.otherBtn.isSelected)
                self.otherTextField.isHidden = !self.otherBtn.isSelected
            })
            .disposed(by: bag)
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
