//
//  OtherTypeOnboardingView.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/06/29.
//

import UIKit

import SnapKit
import Then

class OtherTypeOnboardingView: OnboardingView {
    
    // MARK: - UI components
    
    private let innerView = UIView()
    
    let upperLabel = BaseAttributedLabel(font: AssetFonts.h4,
                                                     text: .empty,
                                                     alignment: .center,
                                                     color: AssetColors.black)
    
    let lowerLabel = BaseAttributedLabel(font: AssetFonts.subtitle2,
                                                 text: .empty,
                                                 alignment: .center,
                                                 color: AssetColors.gray700)
        .then {
            $0.numberOfLines = 0
        }
    
    
    // MARK: - Variables and Properties
    
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Functions
}


// MARK: - Configure

extension OtherTypeOnboardingView {
    
    private func configureContentView() {
        addSubviews([innerView])
        
        innerView.addSubviews([upperLabel, lowerLabel])

    }
    
}


// MARK: - Layout

extension OtherTypeOnboardingView {
    
    private func configureLayout() {
        innerView.snp.makeConstraints {
            $0.top.equalTo(innerImageView.snp.bottom).offset(40.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(96.0)
        }
        
        upperLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(28.0)
        }
        
        lowerLabel.snp.makeConstraints {
            $0.top.equalTo(upperLabel.snp.bottom).offset(16.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(42.0)
        }
    }
    
}
