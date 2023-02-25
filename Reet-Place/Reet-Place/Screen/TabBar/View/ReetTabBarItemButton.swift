//
//  ReetTabBarItemButton.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/24.
//

import UIKit

import Then
import SnapKit

class ReetTabBarItemButton: UIButton {
    
    // MARK: - UI components
    
    private let stackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 2.0
            
            $0.isUserInteractionEnabled = false
        }
    
    let iconImageView = UIImageView()
        .then {
            $0.contentMode = .scaleAspectFit
            $0.isUserInteractionEnabled = false
        }
    
    let nameLabel = BaseAttributedLabel(font: AssetFonts.tooltip, text: nil, alignment: .center, color: AssetColors.gray500)
        .then {
            $0.isUserInteractionEnabled = false
        }
    
    // MARK: - Variables and Properties
    
    let itemType: TabBarItem
    
    // MARK: - Life Cycle
    
    init(frame: CGRect = .zero, for itemType: TabBarItem) {
        self.itemType = itemType
        super.init(frame: frame)
        
        configureButton()
        configreLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func setButtonStatus(isSelected: Bool) {
        let toSetColor = isSelected ? AssetColors.primary500 : AssetColors.gray500
        nameLabel.textColor = toSetColor
        iconImageView.image = itemType.image?.withTintColor(toSetColor)
    }
    
}

// MARK: - Configure

extension ReetTabBarItemButton {
    
    private func configureButton() {
        nameLabel.text = itemType.description
        iconImageView.image = itemType.image
    }
    
}

// MARK: - Layout

extension ReetTabBarItemButton {
    
    private func configreLayout() {
        addSubviews([stackView])
        [iconImageView, nameLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(self).offset(6)
            $0.horizontalEdges.equalTo(self)
            $0.bottom.equalTo(self).inset(6)
        }
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
    }
    
}
