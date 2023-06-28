//
//  OnboardingVC.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/06/28.
//

import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa
import RxGesture

class OnboardingVC: BaseViewController {
    
    // MARK: - UI components
    
    private let baseScrollView = UIScrollView()
        .then {
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
        }
    
    private let innerStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 0.0
            $0.distribution = .fill
            $0.alignment = .fill
        }
    
    private let onboardingFirst = OnboardingView()
        .then {
            $0.innerImageView.image = AssetsImages.onboardingFirst
        }
    
    private let onboardingSecond = OnboardingView()
        .then {
            $0.innerImageView.image = AssetsImages.onboardingSecond
        }
    
    private let onboardingthird = OnboardingView()
        .then {
            $0.innerImageView.image = AssetsImages.onboardingThird
        }
    
    private let onboardingFourth = OnboardingView()
        .then {
            $0.innerImageView.image = AssetsImages.onboardingFourth
        }
    
    
    // MARK: - Variables and Properties
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureView() {
        super.configureView()
        
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        bindBtn()
    }
    
    // MARK: - Functions
    
    
}


// MARK: - Configure

extension OnboardingVC {
    
    private func configureContentView() {
        view.addSubviews([baseScrollView])
        
        baseScrollView.addSubview(innerStackView)
        
        [onboardingFirst, onboardingSecond, onboardingthird, onboardingFourth].forEach {
            innerStackView.addArrangedSubview($0)
        }
    }
    
}


// MARK: - Layout

extension OnboardingVC {
    
    private func configureLayout() {
        baseScrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        innerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(screenWidth * 4)
        }
        
        [onboardingFirst, onboardingSecond, onboardingthird, onboardingFourth].forEach {
            $0.snp.makeConstraints {
                $0.height.equalToSuperview()
                $0.width.equalTo(screenWidth)
            }
        }
    }
    
}


// MARK: - Output

extension OnboardingVC {
    
    private func bindBtn() {
        
    }
    
}
