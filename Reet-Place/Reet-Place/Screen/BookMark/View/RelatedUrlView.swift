//
//  RelatedUrlView.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/19.
//

import UIKit

import Then
import SnapKit

class RelatedUrlView: BaseView {
    
    // MARK: - UI components
    
    let urlLabel = BaseAttributedLabel(font: AssetFonts.caption,
                                          text: nil,
                                          alignment: .left,
                                          color: AssetColors.gray700)
        .then {
            $0.lineBreakMode = .byTruncatingTail
        }
    
    // MARK: - Variables and Properties
        
    // MARK: - Life Cycle
    
    // MARK: - Functions
    
    override func configureView() {
        super.configureView()
        
        self.backgroundColor = AssetColors.gray100
        self.layer.cornerRadius = 2.0

        addSubview(urlLabel)
    }
    
    override func layoutView() {
        super.layoutView()
        
        urlLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.snp.centerY)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
        }
    }
    
}
