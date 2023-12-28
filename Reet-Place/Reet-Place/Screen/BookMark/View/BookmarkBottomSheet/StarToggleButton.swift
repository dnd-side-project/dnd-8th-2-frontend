//
//  ToggleButton.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/26.
//

import UIKit
import SnapKit
import Then

final class StarToggleButton: BaseView {
    
    // MARK: - UI components
    
    private let stackView = UIStackView()
        .then {
            $0.spacing = 0.0
            $0.distribution = .fillEqually
            $0.alignment = .fill
            $0.axis = .horizontal
        }
    
    private let oneStarBtn = UIButton()
        .then {
            $0.tag = 1
            $0.setTitle("★", for: .normal)
        }
    
    private let twoStarBtn = UIButton()
        .then {
            $0.tag = 2
            $0.layer.borderColor = AssetColors.gray300.cgColor
            $0.layer.borderWidth = 1.0
            $0.setTitle("★★", for: .normal)
        }
    
    private let threeStarBtn = UIButton()
        .then {
            $0.tag = 3
            $0.setTitle("★★★", for: .normal)
        }
    
    
    // MARK: - Variables and Properties
    
    private(set) var selectedStarCount: Int = 1
    
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
    
        configureContentView()
        configureBtn()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    
    // MARK: - Functions
    
    @objc func toggleBtnTapped(_ sender: UIButton) {
        [oneStarBtn, twoStarBtn, threeStarBtn].forEach {
            $0.isSelected = false
        }
        
        selectedStarCount = sender.tag
        
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
    
    func setStarCount(_ count: Int) {
        selectedStarCount = count > 3 ? 3 : count
        switch selectedStarCount {
        case 1:
            oneStarBtn.isSelected = true
        case 2:
            twoStarBtn.isSelected = true
        case 3:
            threeStarBtn.isSelected = true
        default:
            threeStarBtn.isSelected = true
        }
    }
    
}


// MARK: - Configure

extension StarToggleButton {
    
    private func configureContentView() {
        layer.cornerRadius = 4.0
        layer.borderColor = AssetColors.gray300.cgColor
        layer.borderWidth = 1.0
        layer.masksToBounds = true
        
        addSubview(stackView)
    }
    
    private func configureBtn() {
        [oneStarBtn, twoStarBtn, threeStarBtn].forEach {
            stackView.addArrangedSubview($0)
            
            $0.titleLabel?.font = AssetFonts.subtitle2.font
            
            $0.setTitleColor(AssetColors.gray500, for: .normal)
            $0.setTitleColor(AssetColors.gray500, for: .highlighted)
            $0.setTitleColor(AssetColors.primary500, for: [.selected, .highlighted])
            $0.setTitleColor(AssetColors.primary500, for: .selected)
            
            $0.setBackgroundColor(AssetColors.white, for: .normal)
            $0.setBackgroundColor(AssetColors.white, for: .highlighted)
            $0.setBackgroundColor(AssetColors.primary50, for: [.selected, .highlighted])
            $0.setBackgroundColor(AssetColors.primary50, for: .selected)
            
            $0.addTarget(self, action: #selector(toggleBtnTapped), for: .touchUpInside)
        }
    }
    
}


// MARK: - Layout

extension StarToggleButton {
    
    private func configureLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
