//
//  ToggleButton.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/26.
//

import UIKit
import SnapKit
import Then

class ToggleButton: BaseView {
    
    let stackView = UIStackView()
        .then {
            $0.spacing = 0.0
            $0.distribution = .fillEqually
            $0.alignment = .fill
            $0.axis = .horizontal
        }
    
    let oneStarBtn = UIButton()
        .then {
            $0.tag = 1
            $0.setTitle("★", for: .normal)
            $0.isSelected = true
        }
    let twoStarBtn = UIButton()
        .then {
            $0.tag = 2
            $0.layer.borderColor = AssetColors.gray300.cgColor
            $0.layer.borderWidth = 1.0
            $0.setTitle("★★", for: .normal)
        }
    let threeStarBtn = UIButton()
        .then {
            $0.tag = 3
            $0.setTitle("★★★", for: .normal)
        }
    
    var selectedTag: Int = 1
    
    override func configureView() {
        super.configureView()
        
        layer.cornerRadius = 4.0
        layer.borderColor = AssetColors.gray300.cgColor
        layer.borderWidth = 1.0
        layer.masksToBounds = true
        
        addSubview(stackView)
        
        [oneStarBtn, twoStarBtn, threeStarBtn].forEach {
            stackView.addArrangedSubview($0)
            $0.titleLabel?.font = AssetFonts.subtitle2.font
            $0.setTitleColor(AssetColors.gray500, for: .normal)
            $0.setTitleColor(AssetColors.primary500, for: .highlighted)
            $0.setTitleColor(AssetColors.primary500, for: [.selected, .highlighted])
            $0.setTitleColor(AssetColors.primary500, for: .selected)
            $0.setBackgroundColor(AssetColors.white, for: .normal)
            $0.setBackgroundColor(AssetColors.primary50, for: .highlighted)
            $0.setBackgroundColor(AssetColors.primary50, for: [.selected, .highlighted])
            $0.setBackgroundColor(AssetColors.primary50, for: .selected)
            $0.addTarget(self, action: #selector(toggleBtnTapped), for: .touchUpInside)
        }
    
    }
    
    override func layoutView() {
        super.layoutView()
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
    }
    
    @objc func toggleBtnTapped(_ sender: UIButton) {
        [oneStarBtn, twoStarBtn, threeStarBtn].forEach {
            $0.isSelected = false
        }
        
        selectedTag = sender.tag
        
        switch sender.tag {
        case 1:
            oneStarBtn.isSelected = true
        case 2:
            twoStarBtn.isSelected = true
        case 3:
            threeStarBtn.isSelected = true
        default:
            fatalError()
        }
    }
    
    
}
