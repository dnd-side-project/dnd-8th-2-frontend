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
                                    text: "장소를 더 입력하고 싶나요?",
                                    alignment: .center,
                                    color: AssetColors.gray500)
    
    let btnView = UIView()
    
    let stackView = UIStackView()
        .then {
            $0.spacing = 4.0
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .horizontal
        }
    
    let bookmarkImage = UIImageView(image: AssetsImages.bookmark)
        .then {
            $0.contentMode = .scaleAspectFit
        }
    
    let goBookmarkLabel = BaseAttributedLabel(font: AssetFonts.buttonSmall, text: "북마크 하러 가기", alignment: .center, color: AssetColors.black)
    
    
    // MARK: - Variables and Properties
    
    let bag = DisposeBag()
        
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureContentView()
        bindBtn()
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
        addSubviews([title, btnView])
        
        btnView.addSubview(stackView)
        
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
        
        btnView.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.width.equalTo(144)
            $0.top.equalTo(title.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.leading.equalTo(btnView).offset(16.0)
            $0.bottom.trailing.equalTo(btnView).offset(-16.0)
        }
    }
    
}

extension InduceBookmarkView {

    private func bindBtn() {

        
    }

}
