//
//  SelectBoxTVC.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/06/01.
//

import UIKit

import SnapKit
import Then

class SelectBoxTVC: BaseTableViewCell {
    
    // MARK: - UI components
    
    private let selectLabel: BaseAttributedLabel = BaseAttributedLabel(font: .body2,
                                                                       text: .empty,
                                                                       alignment: .left,
                                                                       color: AssetColors.black)
    
    
    // MARK: - Variables and Properties
    
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Functions
    
}


// MARK: - Configure

extension SelectBoxTVC {
    
    private func configureContentView() {
        contentView.addSubviews([selectLabel])
        
    }
    
}


// MARK: - Layout

extension SelectBoxTVC {
    
    private func configureLayout() {
        selectLabel.snp.makeConstraints {
            $0.height.equalTo(21.0)
            $0.width.equalTo(96.0)
        }
        
    }
    
}
