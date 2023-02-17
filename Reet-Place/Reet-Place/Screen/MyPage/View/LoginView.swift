//
//  LoginView.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/16.
//

import UIKit

import SnapKit
import Then

class LoginView: UIView {
    let titleLabel = BaseLabel(font: .h4,
                               text: "NeedToSignIn".localized,
                               alignment: .center,
                               color: AssetColors.gray500)
    
    let loginButton = ReetButton(with: "DoLogin".localized,
                                 for: .primary)
    
    private let stackView = UIStackView()
        .then {
            $0.spacing = 24.0
            $0.alignment = .fill
            $0.distribution = .fill
            $0.axis = .vertical
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    private func configureView() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20.0)
            $0.bottom.trailing.equalToSuperview().offset(-20.0)
        }
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(loginButton)
        
        loginButton.snp.makeConstraints {
            $0.height.equalTo(48.0)
        }
    }
}
