//
//  WithPeopleView.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/19.
//

import UIKit

import Then
import SnapKit

class WithPeopleView: BaseView {
    
    // MARK: - UI components
    
    let withLabel = BaseAttributedLabel(font: AssetFonts.caption,
                                        text: "with",
                                        alignment: .center,
                                        color: AssetColors.gray500)
        .then {
            $0.setContentHuggingPriority(.required, for: .horizontal)
        }
    
    let peopleLabel = BaseAttributedLabel(font: AssetFonts.caption,
                                          text: nil,
                                          alignment: .left,
                                          color: AssetColors.black)
    
    
    // MARK: - Variables and Properties
        
    // MARK: - Life Cycle
    
    // MARK: - Functions
    
    override func configureView() {
        super.configureView()
        
        self.backgroundColor = AssetColors.primary50
        self.layer.cornerRadius = 2.0
        
        addSubviews([withLabel, peopleLabel])
        
    }
    
    override func layoutView() {
        super.layoutView()
        
        snp.makeConstraints {
            $0.height.equalTo(30.0)
        }
        
        withLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.snp.centerY)
            $0.leading.equalToSuperview().offset(8)
        }
        
        peopleLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.snp.centerY)
            $0.leading.equalTo(withLabel.snp.trailing).offset(4)
            $0.trailing.equalToSuperview().offset(-8)
        }
    }
}
