//
//  UserProfileView.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/17.
//

import UIKit

import Kingfisher

import SnapKit
import Then

class UserProfileView: UIView {
    
    let imageView = UIImageView(image: AssetsImages.profilePlaceholder)
    
    let nameLabel = BaseLabel(font: .h4,
                              text: nil,
                              alignment: .left,
                              color: AssetColors.black)
    
    let idLabel = BaseLabel(font: .body2,
                            text: nil,
                            alignment: .left,
                            color: AssetColors.gray500)
    
    private let verticalStackView = UIStackView()
        .then {
            $0.spacing = 4.0
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .vertical
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20.0)
            $0.width.height.equalTo(48.0)
        }
        
        addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(idLabel)
        
        verticalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24.0)
            $0.bottom.equalToSuperview().offset(-24.0)
            $0.leading.equalTo(imageView.snp.trailing).offset(16.0)
            $0.trailing.equalToSuperview().offset(-20.0)
        }
    }
    
    func configureProfile(with user: ModelUser) {
        imageView.kf.setImage(with: user.thumbnailUrl.url,
                              placeholder: AssetsImages.profilePlaceholder)
        
        nameLabel.text = user.name
        idLabel.text = "@\(user.id)"
    }
}
