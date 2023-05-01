//
//  AccountDeletedVC.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/05/01.
//

import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa
import RxGesture


class AccountDeletedVC: BaseViewController {
    
    // MARK: - UI components
    
    private let stackView = UIStackView()
        .then {
            $0.spacing = 24.0
            $0.distribution = .fill
            $0.alignment = .center
            $0.axis = .vertical
        }
    
    private let deletedImageView = UIImageView(image: AssetsImages.deletedAccount)
    
    private let deletedTitle = BaseAttributedLabel(font: .h4,
                                                   text: "정상적으로 탈퇴되었어요.",
                                                   alignment: .center,
                                                   color: AssetColors.black)
    
    private let deletedDesc = BaseAttributedLabel(font: .body2,
                                                   text: "지금까지 서비스를 이용해주셔서 감사했습니다 :)\n나의 약속 지도가 필요하다면 다시 찾아주세요!",
                                                   alignment: .center,
                                                   color: AssetColors.gray500)
        .then {
            $0.numberOfLines = .zero
        }
    
    private let goToHomeBtn = ReetButton(with: "홈으로 이동",
                                     for: .outlined)
    
    
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
    
    // MARK: - Functions
    
}


// MARK: - Configure

extension AccountDeletedVC {
    
    private func configureContentView() {
        view.addSubview(stackView)
        
        [deletedImageView, deletedTitle, deletedDesc, goToHomeBtn].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.setCustomSpacing(12.0, after: deletedTitle)
    }
    
}


// MARK: - Layout

extension AccountDeletedVC {
    
    private func configureLayout() {
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        deletedImageView.snp.makeConstraints {
            $0.height.equalTo(160.0)
            $0.width.equalTo(deletedImageView.snp.height)
        }
        
        deletedTitle.snp.makeConstraints {
            $0.height.equalTo(28.0)
        }
        
        deletedDesc.snp.makeConstraints {
            $0.height.equalTo(42.0)
        }
        
        goToHomeBtn.snp.makeConstraints {
            $0.width.equalTo(stackView.snp.width)
        }
    }
    
}
