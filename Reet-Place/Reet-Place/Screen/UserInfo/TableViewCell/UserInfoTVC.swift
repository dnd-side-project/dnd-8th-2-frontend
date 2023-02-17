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
    let infoLabel = BaseLabel(font: .body2,
                              text: nil,
                              alignment: .center,
                              color: AssetColors.gray500)
        .then {
            $0.setContentHuggingPriority(.required, for: .horizontal)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        rightImageView.image = AssetsImages.kakao
        
        // Image view size
        rightImageView.snp.removeConstraints()
        rightImageView.snp.makeConstraints {
            $0.width.equalTo(24.0)
        }
        
        stackView.insertArrangedSubview(infoLabel, at: 1)
    }
    
    
}
