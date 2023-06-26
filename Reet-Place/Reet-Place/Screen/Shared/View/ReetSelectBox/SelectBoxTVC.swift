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
    
    let selectLabel: BaseAttributedLabel = BaseAttributedLabel(font: .body2,
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureInset()
    }
    
    
    // MARK: - Functions
    
    func setLabel(title: String) {
        selectLabel.text = title
        
        if title == "북마크 삭제" {
            selectLabel.textColor = AssetColors.error
        }
    }
    
}


// MARK: - Configure

extension SelectBoxTVC {
    
    private func configureContentView() {
        contentView.addSubviews([selectLabel])
        
    }
    
    private func configureInset() {
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6.0, left: 12.0, bottom: 6.0, right: 12.0))
        
    }
    
}


// MARK: - Layout

extension SelectBoxTVC {
    
    private func configureLayout() {
        selectLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
}
