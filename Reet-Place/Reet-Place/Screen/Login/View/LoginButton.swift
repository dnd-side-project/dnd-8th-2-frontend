//
//  LoginButton.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/04.
//

import UIKit

import Then
import SnapKit

class LoginButton: UIButton {
    
    // MARK: - UI components
    
    private let baseStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.distribution = .fillProportionally
            $0.alignment = .center
            $0.spacing = 10.0
        }
    private let explainLabel = UILabel()
    private let logoImageView = UIImageView()
        .then {
            $0.contentMode = .scaleAspectFit
        }
    
    // MARK: - Variables and Properties
    
    private let type: LoginType
    
    // MARK: - Life Cycle
    
    init(frame: CGRect = .zero,
         type: LoginType) {
        self.type = type
        super.init(frame: frame)
        
        configureButton()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.8 : 1.0
        }
    }
    
    // MARK: - Functions
}

// MARK: - Configure

extension LoginButton {
    
    private func configureButton() {
        logoImageView.image = type.logoImage
        
        explainLabel.text = type.explainText
        explainLabel.textColor = type.explainTextColor
        explainLabel.font = type.explainTextFont
        
        backgroundColor = type.backgroundColor
        layer.cornerRadius = 4.0
    }
    
}

// MARK: - Layout

extension LoginButton {
    
    private func configureLayout() {
        // Add Subviews
        addSubview(baseStackView)
        baseStackView.addArrangedSubview(logoImageView)
        baseStackView.addArrangedSubview(explainLabel)
        
        // Make Constraints
        snp.makeConstraints {
            $0.height.equalTo(55.0)
        }
        baseStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        explainLabel.snp.makeConstraints {
            $0.width.equalTo(explainLabel.intrinsicContentSize.width)
        }
        logoImageView.snp.makeConstraints {
            $0.width.height.equalTo(type.logoImageSize)
        }
    }
    
}
