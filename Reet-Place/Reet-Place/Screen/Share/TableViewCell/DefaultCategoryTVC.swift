//
//  DefaultCategoryTVC.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/16.
//

import UIKit

import SnapKit
import Then

class DefaultCategoryTVC: UITableViewCell {
    
    let titleLabel = BaseLabel(font: .subtitle2,
                               text: nil,
                               alignment: .left,
                               color: AssetColors.black)
        .then {
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }
    
    let rightImageView = UIImageView(image: AssetsImages.chevronRight52)
        .then {
            $0.contentMode = .scaleAspectFit
        }
    
    private let stackView = UIStackView()
        .then {
            $0.spacing = 8.0
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .horizontal
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let selectedView = UIView()
        selectedView.backgroundColor = AssetColors.gray100
        selectedBackgroundView = selectedView
        
        backgroundColor = AssetColors.white
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20.0)
            $0.trailing.equalToSuperview().offset(-20.0)
        }
        
        stackView.addArrangedSubview(titleLabel)
        
        stackView.addArrangedSubview(rightImageView)
        
        rightImageView.snp.makeConstraints {
            $0.width.equalTo(rightImageView.snp.height)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = .empty
    }
    
}
