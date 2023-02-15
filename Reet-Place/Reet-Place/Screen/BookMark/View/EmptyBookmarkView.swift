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
    
    let titleLabel = BaseLabel(font: AssetFonts.h4, text: "북마크를 생성해보세요!")
        .then {
            $0.textColor = AssetColors.black
            $0.textAlignment = .center
        }
    
    let contentLabel = BaseLabel(font: AssetFonts.body2, text: "특별한 장소를 저장하고,\n나만의 지도를 채워보세요.")
        .then {
            $0.textColor = AssetColors.gray500
            $0.numberOfLines = .zero
            $0.textAlignment = .center
        }
    
    let aroundMeBtn = ReetButton(with: "내 주변 둘러보기", for: ReetButtonStyle.secondary)
    
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
