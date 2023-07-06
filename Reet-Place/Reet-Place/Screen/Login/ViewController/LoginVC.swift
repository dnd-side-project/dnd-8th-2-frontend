//
//  LoginVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/04.
//

import UIKit

//import RxSwift
//import RxCocoa

import Then
import SnapKit

class LoginVC: BaseViewController {
    
    // MARK: - UI components
    
    private let titleStackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 24.0
        }
    private let titleLabel = BaseAttributedLabel(font: .body2, text: "ReetPlaceTitleExplain".localized, alignment: .center, color: AssetColors.gray500)
    private let titleImageView = UIImageView(image: AssetsImages.reetPlaceTitle)
    
    private let loginTypeStackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 16.0
        }
    private let loginLaterButton = UIButton()
        .then {
            $0.titleLabel?.font = AssetFonts.caption.font
            $0.setTitleColor(AssetColors.gray500, for: .normal)
            $0.setTitle("LoginLater".localized, for: .normal)
        }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindButton()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
    }
    
    // MARK: - Functions
    
}

// MARK: - Configure

extension LoginVC {
    
}

// MARK: - Layout

extension LoginVC {
    
    private func configureLayout() {
        // Add Subviews
        view.addSubviews([titleStackView,
                         loginTypeStackView])
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleImageView)
        
        loginTypeStackView.addArrangedSubview(UIView())
        loginTypeStackView.addArrangedSubview(loginLaterButton)
        
        // Make Constraints
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(view).offset(156.0)
            $0.centerX.equalTo(view)
        }
        
        loginTypeStackView.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16.0)
        }
        
        loginTypeStackView.backgroundColor = .yellow
        loginLaterButton.snp.makeConstraints {
            $0.width.equalTo(96.0)
            $0.height.equalTo(38.0)
        }
    }
    
}

// MARK: - Input

extension LoginVC {
    
    private func bindButton() {
        loginLaterButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.dismissVC()
            })
            .disposed(by: bag)

//        searchButton.rx.tap
//            .bind(onNext: { [weak self] in
//                guard let self = self else { return }
//
//
//            })
//            .disposed(by: bag)
    }
    
}

// MARK: - Output

extension LoginVC {
    
}
