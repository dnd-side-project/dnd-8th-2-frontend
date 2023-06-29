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
    
    private let onboardingFirst = FirstTypeOnboardingView()
        .then {
            $0.innerImageView.image = AssetsImages.onboardingFirst
        }
    
    private let onboardingSecond = OtherTypeOnboardingView()
        .then {
            $0.innerImageView.image = AssetsImages.onboardingSecond
            $0.upperLabel.text = "릿플 인기"
            $0.lowerLabel.text = "릿플 인기로 내 근처 약속 장소를\n자유롭게 확인하고 수정할 수 있어요!"
        }
    
    private let onboardingthird = OtherTypeOnboardingView()
        .then {
            $0.innerImageView.image = AssetsImages.onboardingThird
            $0.upperLabel.text = "북마크 저장"
            $0.lowerLabel.text = "마음에 드는 장소가 있다면\n북마크에 저장하세요!"
        }
    
    private let onboardingFourth = OtherTypeOnboardingView()
        .then {
            $0.innerImageView.image = AssetsImages.onboardingFourth
            $0.upperLabel.text = "북마크 확인"
            $0.lowerLabel.text = "불시에 약속 장소를 변경할 일이 생긴다면\n저장한 북마크를 확인해봐요!"
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
