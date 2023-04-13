//
//  RelatedUrlView.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/19.
//

import UIKit

import Then
import SnapKit

class RelatedUrlButton: UIButton {
        
    let urlLabel = BaseAttributedLabel(font: AssetFonts.caption,
                                          text: nil,
                                          alignment: .left,
                                          color: AssetColors.gray700)
        .then {
            $0.lineBreakMode = .byTruncatingTail
        }
    
        
    override init(frame: CGRect = .zero) {
        
        super.init(frame: frame)
        
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureButton() {
        setBackgroundColor(AssetColors.gray100, for: .normal)
        setBackgroundColor(AssetColors.gray200, for: .highlighted)
        layer.cornerRadius = 2.0
        
        addSubview(urlLabel)
        
        urlLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.snp.centerY)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
        }
    }

    
}
