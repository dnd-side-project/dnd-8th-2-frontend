//
//  FirstTypeOnboardingView.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/06/29.
//

import UIKit

import SnapKit
import Then

class FirstTypeOnboardingView: OnboardingView {
    
    // MARK: - UI components
    
    let innerView = UIView()
    
    private let firstLineLabel = BaseAttributedLabel(font: AssetFonts.h4,
                                                     text: "FirstOnboardingFirstLine".localized,
                                                     alignment: .center,
                                                     color: AssetColors.primary500)
    
    private let secondLineLabel = BaseAttributedLabel(font: AssetFonts.h4,
                                                      text: "FirstOnboardingSecondLine".localized,
                                                      alignment: .center,
                                                      color: AssetColors.black)
    
    private let thirdLineLabel = BaseAttributedLabel(font: AssetFonts.h4,
                                                         text: .empty,
                                                         alignment: .center,
                                                         color: AssetColors.primary500)
    
    
    // MARK: - Variables and Properties
    
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureContentView()
        setThirdLineLabel()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Functions
}


// MARK: - Configure

extension FirstTypeOnboardingView {
    
    private func configureContentView() {
        addSubviews([innerView])
        
        innerView.addSubviews([firstLineLabel, secondLineLabel, thirdLineLabel])
        
    }
    
    private func setThirdLineLabel() {
        let attributedText = NSMutableAttributedString(string: "FirstOnboardingThirdLine".localized)
        
        let range = ("FirstOnboardingThirdLine".localized as NSString).range(of: "Reet Place")
        
        attributedText.addAttribute(.foregroundColor, value: AssetColors.primary500, range: range)
        attributedText.setAttr(with: AssetFonts.h4, alignment: .center)
        
        thirdLineLabel.attributedText = attributedText
    }
    
}


// MARK: - Layout

extension FirstTypeOnboardingView {
    
    private func configureLayout() {
        innerView.snp.makeConstraints {
            $0.top.equalTo(innerImageView.snp.bottom).offset(40.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(96.0)
        }
        
        firstLineLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(28.0)
        }
        
        secondLineLabel.snp.makeConstraints {
            $0.top.equalTo(firstLineLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(28.0)
        }
        
        thirdLineLabel.snp.makeConstraints {
            $0.top.equalTo(secondLineLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(28.0)
        }
    }
    
}
