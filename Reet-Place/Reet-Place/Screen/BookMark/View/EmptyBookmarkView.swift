//
//  EmptyBookmarkView.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/16.
//

import UIKit

import Then
import SnapKit

class EmptyBookmarkView: BaseView {
    
    // MARK: - UI components
    
    let titleLabel = BaseAttributedLabel(font: AssetFonts.h4,
                                         text: "EmptyBookmarkTitle".localized,
                                         alignment: .center,
                                         color: AssetColors.black)
    
    let contentLabel = BaseAttributedLabel(font: AssetFonts.body2,
                                           text: "EmptyBookmarkDesc".localized,
                                           alignment: .center,
                                           color: AssetColors.gray500)
        .then {
            $0.numberOfLines = .zero
        }
    
    let aroundMeBtn = ReetButton(with: "ArroundMe".localized,
                                 for: ReetButtonStyle.secondary)
    
    let stackView = UIStackView()
        .then {
            $0.alignment = .fill
            $0.distribution = .fill
            $0.axis = .vertical
        }
    
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    // MARK: - Functions
    
    override func configureView() {
        super.configureView()
        
        self.backgroundColor = .white
    }
    
    override func layoutView() {
        super.layoutView()
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        aroundMeBtn.snp.makeConstraints {
            $0.height.equalTo(48.0)
        }
        
        [titleLabel, contentLabel, aroundMeBtn].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.setCustomSpacing(12.0, after: titleLabel)
        stackView.setCustomSpacing(40.0, after: contentLabel)
    }
}
