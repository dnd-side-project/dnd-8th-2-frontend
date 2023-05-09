//
//  InduceBookmarkView.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/03/03.
//

import UIKit

import Then
import SnapKit

import RxSwift
import RxGesture
import RxCocoa


class InduceBookmarkView: BaseView {
    
    // MARK: - UI components
    
    let title = BaseAttributedLabel(font: AssetFonts.caption,
                                    text: "InduceBookmarkTitle".localized,
                                    alignment: .center,
                                    color: AssetColors.gray500)
    
    let goBookmarkBtn = UIButton(type: .system)
    
    let stackView = UIStackView()
        .then {
            $0.spacing = 4.0
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .horizontal
            $0.isUserInteractionEnabled = false
        }
    
    let bookmarkImage = UIImageView(image: AssetsImages.bookmark)
        .then {
            $0.contentMode = .scaleAspectFit
        }
    
    let goBookmarkLabel = BaseAttributedLabel(font: AssetFonts.buttonSmall,
                                              text: "InduceBookmarkDesc".localized,
                                              alignment: .center,
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

extension InduceBookmarkView {
    
    private func configureContentView() {
        addSubviews([title, goBookmarkBtn])
        
        goBookmarkBtn.addSubview(stackView)
        
        [bookmarkImage, goBookmarkLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
    }
    
}

// MARK: - Layout

extension InduceBookmarkView {
    
    private func configureLayout() {
        title.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        goBookmarkBtn.snp.makeConstraints {
            $0.height.equalTo(48.0)
            $0.width.equalTo(144.0)
            $0.top.equalTo(title.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.leading.equalTo(goBookmarkBtn).offset(16.0)
            $0.bottom.trailing.equalTo(goBookmarkBtn).offset(-16.0)
        }
    }
    
}
