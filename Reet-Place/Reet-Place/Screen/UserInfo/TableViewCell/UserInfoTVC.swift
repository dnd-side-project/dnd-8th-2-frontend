//
//  UserInfoTVC.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/17.
//

import UIKit

import Then
import SnapKit

class UserInfoTVC: DefaultCategoryTVC {
    
    // MARK: - UI components
    
    private let infoLabel = BaseAttributedLabel(font: .body2,
                                                text: nil,
                                                alignment: .center,
                                                color: AssetColors.gray500)
        .then {
            $0.setContentHuggingPriority(.required, for: .horizontal)
        }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureRightImageView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureUserInfoTVCLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        infoLabel.text = .empty
        rightImageView.isHidden = false
    }
    
}

// MARK: - Configure

extension UserInfoTVC {
    
    /// 회원정보VC에 있는 userInfoTableView의 UserInfoTVC의 정보를 입력
    func configureUserInfoTVC(infoMenuType: UserInfoMenu, userInformation: UserInfomation) {
        titleLabel.text = infoMenuType.description
        titleLabel.textColor = infoMenuType.foregroundColor
        
        switch infoMenuType {
        case .sns:
            infoLabel.text = userInformation.email
            rightImageView.image = LoginType(rawValue: userInformation.loginType)?.accountProviderSNSIcon
            rightImageView.backgroundColor = AssetColors.black
        case .delete:
            rightImageView.isHidden = true
        }
    }
    
    private func configureRightImageView() {
        rightImageView.layer.cornerRadius = 12.0
        rightImageView.clipsToBounds = true
    }
    
}

// MARK: - Layout

extension UserInfoTVC {
    
    private func configureUserInfoTVCLayout() {
        baseStackView.insertArrangedSubview(infoLabel, at: 1)
        
        baseStackView.snp.updateConstraints {
            $0.trailing.equalToSuperview().offset(-defaultHorizontalOffset)
        }
        rightImageView.snp.updateConstraints {
            $0.width.height.equalTo(rightImageView.layer.cornerRadius * 2)
        }
    }
    
}
