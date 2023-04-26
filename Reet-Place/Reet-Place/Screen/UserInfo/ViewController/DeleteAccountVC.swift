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
    
    let descStackView = UIStackView()
        .then {
            $0.spacing = 12.0
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .vertical
        }
    
    let confirmTitle = BaseAttributedLabel(font: .subtitle1,
                                           text: "탈퇴 신청 전 확인해주세요.",
                                           alignment: .left,
                                           color: AssetColors.primary500)
    
    let confirmDescView = UIView()
        .then {
            $0.backgroundColor = AssetColors.primary50
        }
    
    let confirmDesc = BaseAttributedLabel(font: .body2,
                                          text: "탈퇴 이후 회원 정보 및 이용기록은 모두 삭제되며,\n당신의 멋진 지도는 다시 복구할 수 없어요.",
                                          alignment: .center,
                                          color: AssetColors.gray700)
        .then {
            $0.numberOfLines = .zero
        }
    
    let checkTitle = BaseAttributedLabel(font: .subtitle1,
                                        text: "떠나시는 이유가 무엇인가요?",
                                        alignment: .left,
                                        color: AssetColors.black)
    
    let checkDesc = BaseAttributedLabel(font: .body2,
                                        text: "더 나은 서비스 개선 목적의 자료로 사용할게요.",
                                        alignment: .left,
                                        color: AssetColors.gray500)
    
    let checkboxStackView = UIStackView()
        .then {
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .vertical
        }
    
    let recordDeleteBtn = CheckboxButton(with: "기록 삭제 목적")
    let lowUsedBtn = CheckboxButton(with: "사용 빈도가 낮아서")
    let useOtherServiceBtn = CheckboxButton(with: "다른 서비스 사용 목적")
    let inconvenienceBtn = CheckboxButton(with: "이용이 불편하고 장애가 많아서")
    let contentComplaintBtn = CheckboxButton(with: "콘텐츠 불만")
    let otherBtn = CheckboxButton(with: "기타")
    
    let deleteBtn = ReetButton(with: "탈퇴하기",
                               for: .outlined)
    
    
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
    
    override func bindInput() {
        super.bindInput()
        
        
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        
    }
    
    // MARK: - Functions
    
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
        
        [recordDeleteBtn, lowUsedBtn, useOtherServiceBtn, inconvenienceBtn, contentComplaintBtn, otherBtn].forEach {
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
        
        [recordDeleteBtn, lowUsedBtn, useOtherServiceBtn, inconvenienceBtn, contentComplaintBtn, otherBtn].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(40)
            }
        }
        
        deleteBtn.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20.0)
        }
    }
    
}

