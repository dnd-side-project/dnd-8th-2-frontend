//
//  NavigationBar.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/16.
//

import UIKit

import SnapKit
import Then

class NavigationBar: UIView {
    let titleLabel = BaseLabel(font: .h3, text: nil)
    
    let leftButton = UIButton(type: .system)
        .then {
            $0.setImage(AssetsImages.chevronLeft48, for: .normal)
        }
    
    let rightButton = UIButton(type: .system)
        .then {
            $0.setImage(AssetsImages.cancel48, for: .normal)
        }
    
    var style: BarStyle {
        didSet {
            updateVisability()
        }
    }
    
    private let height: CGFloat
    
    private let borderStackView = UIStackView()
        .then {
            $0.spacing = .zero
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .vertical
        }
    
    private let contentStackView = UIStackView()
        .then {
            $0.spacing = .zero
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .horizontal
        }
    
    private let borderView = UIView()
        .then {
            $0.backgroundColor = AssetColors.black
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect = .zero,
         style: BarStyle,
         title: String?,
         height: CGFloat = 48.0) {
        self.style = style
        self.height = height
        
        super.init(frame: frame)
        
        self.titleLabel.text = title
        
        configureView()
    }
    
    func configureView() {
        backgroundColor = AssetColors.white
        
        addSubview(borderStackView)
        borderStackView.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview().priority(.low)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        borderStackView.addArrangedSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.height.equalTo(height)
        }
        
        [leftButton, titleLabel, rightButton].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        leftButton.snp.makeConstraints {
            $0.width.equalTo(leftButton.snp.height)
        }
        
        borderStackView.addArrangedSubview(borderView)
        borderView.snp.makeConstraints {
            $0.height.equalTo(1.0)
        }
        
        updateVisability()
    }
    
    func updateVisability() {
        [leftButton, rightButton].forEach { $0.isHidden = false }
        
        var inset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
        
        switch style {
        case .default:
            leftButton.isHidden = true
            rightButton.isHidden = true
            
            inset.left = 20.0
            
        case .left:
            rightButton.isHidden = true
            
        case .right:
            leftButton.isHidden = true
            
            inset.left = 20.0
        }
        
        contentStackView.layoutMargins = inset
        contentStackView.isLayoutMarginsRelativeArrangement = true
    }
    
}

extension NavigationBar {
    enum BarStyle {
        case `default`
        case left
        case right
    }
}
