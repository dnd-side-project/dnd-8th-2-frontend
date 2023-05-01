//
//  ServicePolicyVC.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/04/24.
//

import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

class ServicePolicyVC: BaseNavigationViewController {
    
    // MARK: - UI components
    
    private let servicePolicyTextView = UITextView()
    
    
    // MARK: - Variables and Properties
    
    let terms =
    """
    ReetPlace 이용약관
    
    제1조 (목적)
    이 약관은 ReetPlace(이하 "회사"라 함)이 제공하는 모든 서비스의 이용 조건 및 절차, 회원과 회사간의 권리와 의무, 책임 사항 등 기본적인 사항을 규정함을 목적으로 합니다.

    제2조 (용어의 정의)
    본 약관에서 사용되는 주요한 용어의 정의는 다음과 같습니다.

    1. 서비스: 회사가 제공하는 인터넷 관련 제반 서비스를 의미합니다.
    2. 회원: 회사와 서비스 이용계약을 체결하고 이용자 ID를 부여받은 자를 말합니다.
    3. 이용자 ID: 회원의 식별과 서비스 이용을 위하여 회원이 선정하고 회사가 승인하는 영문자와 숫자의 조합을 의미합니다.
    4. 비밀번호: 회원이 부여받은 이용자 ID와 일치된 회원임을 확인하고 회원의 권익과 개인정보 보호를 위해 회원 자신이 선정한 문자 또는 숫자의 조합을 의미합니다.
    5. 게시물: 회원이 서비스를 이용함에 있어 회사에 제공한 부호·문자·음성·음향·화상·동영상 등의 정보 또는 자료를 말합니다.
    6. 포인트: 회사가 서비스의 효율적 이용을 위하여 회원에게 부여하는 가상의 적립금을 의미합니다.

    제3조 (약관의 효력 및 변경)
    1. 이 약관은 회원가입 화면에 게시하거나 기타의 방법으로 회원에게 공지함으로써 효력이 발생합니다.
    2. 회사는 상황에 따라 이용약관을 변경할 수 있으며, 변경된 약관은 서비스 내의 적절한 장소에 게시하거나 기타의 방법으로 회원에게 공지함으로써 효력이 발생합니다.
    3. 회원은 변경된 약관에 대해 거부할 권리가 있습니다. 회원은 변경된 약관이 공지된 후 7일 이내에 이의제기를 할 수 있으며, 이 기간 내에 이의를 제기하지 않으면 변경된 약관에 동의한 것으로 간주됩니다.

    제3조 (약관의 효력 및 변경)
    1. 이 약관은 회원가입 화면에 게시하거나 기타의 방법으로 회원에게 공지함으로써 효력이 발생합니다.
    2. 회사는 상황에 따라 이용약관을 변경할 수 있으며, 변경된 약관은 서비스 내의 적절한 장소에 게시하거나 기타의 방법으로 회원에게 공지함으로써 효력이 발생합니다.
    3. 회원은 변경된 약관에 대해 거부할 권리가 있습니다. 회원은 변경된 약관이 공지된 후 7일 이내에 이의제기를 할 수 있으며, 이 기간 내에 이의를 제기하지 않으면 변경된 약관에 동의한 것으로 간주됩니다.
    
    제3조 (약관의 효력 및 변경)
    1. 이 약관은 회원가입 화면에 게시하거나 기타의 방법으로 회원에게 공지함으로써 효력이 발생합니다.
    2. 회사는 상황에 따라 이용약관을 변경할 수 있으며, 변경된 약관은 서비스 내의 적절한 장소에 게시하거나 기타의 방법으로 회원에게 공지함으로써 효력이 발생합니다.
    3. 회원은 변경된 약관에 대해 거부할 권리가 있습니다. 회원은 변경된 약관이 공지된 후 7일 이내에 이의제기를 할 수 있으며, 이 기간 내에 이의를 제기하지 않으면 변경된 약관에 동의한 것으로 간주됩니다.
    """
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func configureView() {
        super.configureView()
        
        configureNaviBar()
        configureServicePolicy()
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

extension ServicePolicyVC {
    
    private func configureNaviBar() {
        navigationBar.style = .left
        title = "이용 약관"
    }
    
    private func configureServicePolicy() {
        view.addSubview(servicePolicyTextView)
        
        servicePolicyTextView.text = terms
        servicePolicyTextView.font = AssetFonts.body2.font
        servicePolicyTextView.textColor = AssetColors.black
        servicePolicyTextView.backgroundColor = AssetColors.gray100
        servicePolicyTextView.isScrollEnabled = true
        servicePolicyTextView.showsVerticalScrollIndicator = false
    }
    
}


// MARK: - Layout

extension ServicePolicyVC {
    
    private func configureLayout() {
        servicePolicyTextView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(20.0)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}
