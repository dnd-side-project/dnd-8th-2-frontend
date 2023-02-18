//
//  AllBookmarkButton.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/15.
//

import UIKit

import Then
import SnapKit

class AllBookmarkButton: UIButton {
    enum AllButtonStyle: String {
        case active
        case disabled
    }
    
    let style: AllButtonStyle
    
    let leftAllLabel = BaseAttributedLabel(font: AssetFonts.subtitle2,
                                           text: "ALL",
                                           alignment: .center,
                                           color: AssetColors.white)
        .then {
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
        }
    
    let allTitleLabel = BaseAttributedLabel(font: AssetFonts.subtitle1,
                                  text: "전체보기",
                                  alignment: .left,
                                  color: AssetColors.black)
        .then {
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }
    
    let countLabel = UILabel()
        .then {
            $0.textAlignment = .right
        }
    
    let rightImageView = UIImageView(image: AssetsImages.chevronRight52)
        .then {
            $0.contentMode = .scaleAspectFit
        }
    
    private let stackView = UIStackView()
        .then {
            $0.isUserInteractionEnabled = false
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .horizontal
        }
    
    
    init(frame: CGRect = .zero,
         count: Int){
        
        if count > 0 {
            self.style = .active
        } else {
            self.style = .disabled
        }
        
        super.init(frame: frame)
        
        configureButton(for: style, count: count)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton(for style: AllButtonStyle, count: Int) {
        
        // stackView 구성
        addSubview(stackView)

        leftAllLabel.snp.makeConstraints {
            $0.height.width.equalTo(36)
        }
        
        stackView.addArrangedSubview(leftAllLabel)
        stackView.addArrangedSubview(allTitleLabel)
        
        stackView.addArrangedSubview(countLabel)
        countLabel.text = String(count)
        
        stackView.addArrangedSubview(rightImageView)
        rightImageView.snp.makeConstraints {
            $0.width.equalTo(rightImageView.snp.height)
        }
        
        
        stackView.setCustomSpacing(16.0, after: leftAllLabel)
        stackView.setCustomSpacing(16.0, after: countLabel)
        
        
        stackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.bottom.trailing.equalToSuperview().offset(-20)
        }
    
        
        // style
        // - .active: 북마크가 있을 때
        // - .disabled: 북마크가 없을 때
        switch style {
        case .active:
            setBackgroundColor(AssetColors.primary50, for: .normal)
            setBackgroundColor(AssetColors.primary50, for: .highlighted)
            setBackgroundColor(AssetColors.primary50, for: .disabled)
            leftAllLabel.backgroundColor = AssetColors.primary500
            countLabel.textColor = AssetColors.primary500
            self.isEnabled = true
        case .disabled:
            setBackgroundColor(AssetColors.gray100, for: .normal)
            leftAllLabel.backgroundColor = AssetColors.gray500
            countLabel.textColor = AssetColors.gray500
            rightImageView.isHidden = true
            self.isEnabled = false
        }
        
    }
}
