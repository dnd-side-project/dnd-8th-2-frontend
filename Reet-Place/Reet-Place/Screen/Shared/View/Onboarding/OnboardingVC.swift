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
            $0.upperLabel.text = "SecondOnboardingUpper".localized
            $0.lowerLabel.text = "SecondOnboardingLower".localized
        }
    
    private let onboardingthird = OtherTypeOnboardingView()
        .then {
            $0.innerImageView.image = AssetsImages.onboardingThird
            $0.upperLabel.text = "ThirdOnboardingUpper".localized
            $0.lowerLabel.text = "ThirdOnboardingLower".localized
        }
    
    private let onboardingFourth = OtherTypeOnboardingView()
        .then {
            $0.innerImageView.image = AssetsImages.onboardingFourth
            $0.upperLabel.text = "FourthOnboardingUpper".localized
            $0.lowerLabel.text = "FourthOnboardingLower".localized
        }
    
    private let progressStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 12.0
            $0.distribution = .fillEqually
            $0.alignment = .fill
        }
    
    private let cancelBtn = UIButton(type: .system)
        .then {
            $0.setImage(AssetsImages.cancel44, for: .normal)
        }
    
    private let startBtn = ReetButton(with: "StartReetPlace".localized,
                                     for: ReetButtonStyle.secondary)
    
    
    // MARK: - Variables and Properties
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureView() {
        super.configureView()
        
        configureContentView()
        configureProgress()
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
    
    /// page에 따라 progress 상태 변경
    func setProgress(page: Int) {
        for idx in 0 ..< 4 {
            if page == idx {
                progressStackView.arrangedSubviews[idx].backgroundColor = AssetColors.primary500
            } else {
                progressStackView.arrangedSubviews[idx].backgroundColor = AssetColors.gray300
            }
        }
    }
    
    /// X 버튼, ReetPlace 시작하기 버튼 눌렀을 때 로그인 화면으로 이동
    func goToLogin() {
        print("TODO: - Go to login")
    }
    
}


// MARK: - Configure

extension OnboardingVC {
    
    private func configureContentView() {
        view.addSubviews([baseScrollView, progressStackView, cancelBtn, startBtn])
        
        baseScrollView.addSubview(innerStackView)
        
        [onboardingFirst, onboardingSecond, onboardingthird, onboardingFourth].forEach {
            innerStackView.addArrangedSubview($0)
        }
        
        baseScrollView.delegate = self
    }
    
    private func configureProgress() {
        for _ in 0 ..< 4 {
            let innerView = UIView()
            innerView.backgroundColor = AssetColors.gray300
            innerView.layer.cornerRadius = 4.0
            progressStackView.addArrangedSubview(innerView)
        }
        
        progressStackView.arrangedSubviews[0].backgroundColor = AssetColors.primary500
    }
    
}


// MARK: - Layout

extension OnboardingVC {
    
    private func configureLayout() {
        baseScrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
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
        
        progressStackView.snp.makeConstraints {
            $0.top.equalTo(onboardingFirst.innerView.snp.bottom).offset(56.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(68.0)
            $0.height.equalTo(8.0)
        }
        
        cancelBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalToSuperview().offset(-16.0)
            $0.height.width.equalTo(44.0)
        }
        
        startBtn.snp.makeConstraints {
            $0.height.equalTo(48.0)
            $0.leading.equalToSuperview().offset(20.0)
            $0.trailing.equalToSuperview().offset(-20.0)
            $0.bottom.equalToSuperview().offset(-56.0)
        }
    }
    
}


// MARK: - Output

extension OnboardingVC {
    
    private func bindBtn() {
        cancelBtn.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.goToLogin()
            })
            .disposed(by: bag)
        
        startBtn.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.goToLogin()
            })
            .disposed(by: bag)
    }
    
}


// MARK: - UIScrollViewDelegate

extension OnboardingVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / screenWidth)
        
        if !page.isInfinite && !page.isNaN {
            setProgress(page: Int(page))
        }
    }
    
}
