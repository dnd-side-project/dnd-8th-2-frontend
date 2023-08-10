//
//  OnboardingView.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/06/28.
//

import UIKit

import SnapKit
import Then

class OnboardingView: BaseView {
    
    // MARK: - UI components
    
    let innerImageView = UIImageView()
    
    
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

extension OnboardingView {
    
    private func configureContentView() {
        addSubviews([innerImageView])
    }
    
}


// MARK: - Layout

extension OnboardingView {
    
    private func configureLayout() {
        innerImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.size.width * 1.15)
        }
    }
    
}
