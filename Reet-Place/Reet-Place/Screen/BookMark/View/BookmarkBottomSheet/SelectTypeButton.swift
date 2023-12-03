//
//  SelectTypeButton.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/27.
//

import UIKit
import SnapKit
import Then

protocol TypeSelectAction: AnyObject {
    func typeChange(type: Int)
}

class SelectTypeButton: BaseView {
    
    // MARK: - UI components
    
    let stackView = UIStackView()
        .then {
            $0.spacing = 8.0
            $0.distribution = .fillEqually
            $0.alignment = .fill
            $0.axis = .horizontal
        }
    
    let wishBtn = UIButton()
        .then {
            $0.tag = 1
            $0.setTitle("가고싶어요", for: .normal)
        }
    
    let historyBtn = UIButton()
        .then {
            $0.tag = 2
            $0.setTitle("다녀왔어요", for: .normal)
        }
    
    
    // MARK: - Variables and Properties
    
    private var selectedTag: Int = 1
    
    weak var delegate: TypeSelectAction?
    
    var selectedType: BookmarkSearchType {
        selectedTag == 1 ? .want : .done
    }
    
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureContentView()
        configureWishBtn()
        configureHistoryBtn()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    
    // MARK: - Functions
    
    @objc func selectType(_ sender: UIButton) {
        [wishBtn, historyBtn].forEach {
            $0.isSelected = false
            $0.layer.borderColor = AssetColors.gray300.cgColor
            $0.layer.borderWidth = 1.0
        }
        
        selectedTag = sender.tag
        
        delegate?.typeChange(type: selectedTag)
        
        switch sender.tag {
        case 1:
            wishBtn.isSelected = true
            wishBtn.layer.borderColor = AssetColors.primary500.cgColor
            wishBtn.layer.borderWidth = 2.0
        case 2:
            historyBtn.isSelected = true
            historyBtn.layer.borderColor = AssetColors.gray800.cgColor
            historyBtn.layer.borderWidth = 2.0
        default:
            fatalError()
        }
    }
    
}


// MARK: - Configure

extension SelectTypeButton {
    
    private func configureContentView() {
        addSubview(stackView)
        
        [wishBtn, historyBtn].forEach {
            stackView.addArrangedSubview($0)
            $0.layer.cornerRadius = 4.0
            $0.layer.masksToBounds = true
            
            $0.titleLabel?.font = AssetFonts.buttonSmall.font
            $0.setTitleColor(AssetColors.gray500, for: .normal)
            $0.setTitleColor(AssetColors.gray500, for: .highlighted)
            $0.setBackgroundColor(AssetColors.gray100, for: .normal)
            $0.setBackgroundColor(AssetColors.gray100, for: .highlighted)
            
            $0.addTarget(self, action: #selector(selectType), for: .touchUpInside)
        }
    }
    
}


// MARK: - Layout

extension SelectTypeButton {
    
    private func configureLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}


// MARK: - Configure Button

extension SelectTypeButton {
    
    func configureWishBtn() {
        wishBtn.layer.borderColor = AssetColors.black.cgColor
        wishBtn.layer.borderWidth = 2.0
        
        wishBtn.setTitleColor(AssetColors.primary500, for: [.selected, .highlighted])
        wishBtn.setTitleColor(AssetColors.primary500, for: .selected)
        
        wishBtn.setBackgroundColor(AssetColors.primary50, for: [.selected, .highlighted])
        wishBtn.setBackgroundColor(AssetColors.primary50, for: .selected)
    }
    
    func configureHistoryBtn() {
        historyBtn.layer.borderColor = AssetColors.gray800.cgColor
        historyBtn.layer.borderWidth = 1.0
        
        historyBtn.setTitleColor(AssetColors.gray800, for: [.selected, .highlighted])
        historyBtn.setTitleColor(AssetColors.gray800, for: .selected)
        
        historyBtn.setBackgroundColor(AssetColors.gray100, for: [.selected, .highlighted])
        historyBtn.setBackgroundColor(AssetColors.gray100, for: .selected)
    }
    
}
