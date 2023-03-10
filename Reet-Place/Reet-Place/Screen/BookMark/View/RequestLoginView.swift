//
//  RequestLoginView.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/16.
//

import UIKit

import Then
import SnapKit

class RequestLoginView: BaseView {
    // MARK: - UI components
    
    let titleLabel = BaseAttributedLabel(font: AssetFonts.h4,
                               text: "로그인하고, 지도를 완성시켜보세요!")
        .then {
            $0.textColor = AssetColors.black
            $0.textAlignment = .center
        }
    
    let contentLabel = BaseAttributedLabel(font: AssetFonts.body2,
                                 text: "숨겨진 장소를 나만의 약속으로!\n지금 로그인하고 나만의 지도를 완성시켜보세요")
        .then {
            $0.textColor = AssetColors.gray500
            $0.numberOfLines = .zero
            $0.textAlignment = .center
        }
    
    let aroundMeBtn = ReetButton(with: "로그인하기",
                                 for: ReetButtonStyle.primary)
    
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
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(contentLabel)
        stackView.addArrangedSubview(aroundMeBtn)
        
        stackView.setCustomSpacing(12.0, after: titleLabel)
        stackView.setCustomSpacing(40.0, after: contentLabel)
    }
}
