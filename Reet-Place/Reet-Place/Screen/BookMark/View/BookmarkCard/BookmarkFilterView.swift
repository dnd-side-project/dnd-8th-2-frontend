//
//  BookmarkFilterView.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/19.
//

import UIKit

import Then
import SnapKit

class BookmarkFilterView: BaseView {
    // MARK: - UI components
    
    let starFilterStackView = UIStackView()
        .then {
            $0.spacing = 4.0
            $0.distribution = .fill
            $0.alignment = .center
            $0.axis = .horizontal
        }
    
    let starFilterLabel = BaseAttributedLabel(font: .caption,
                                               text: "★ 전체보기",
                                               alignment: .left,
                                               color: AssetColors.gray500)
    let starExpanMoreImageView = UIImageView(image: AssetsImages.expandMore16)
        .then {
            $0.tintColor = AssetColors.gray500
            $0.contentMode = .scaleAspectFit
        }
    
    
    let recentFilterStackView = UIStackView()
        .then {
            $0.spacing = 4.0
            $0.distribution = .fill
            $0.alignment = .center
            $0.axis = .horizontal
        }
    let recentFilterLabel = BaseAttributedLabel(font: .caption,
                                               text: "최신등록순",
                                               alignment: .left,
                                               color: AssetColors.gray500)
    let recentExpanMoreImageView = UIImageView(image: AssetsImages.expandMore16)
        .then {
            $0.tintColor = AssetColors.gray500
            $0.contentMode = .scaleAspectFit
        }
    
    let contentBorder = UIView()
        .then {
            $0.backgroundColor = AssetColors.gray300
        }
    
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    // MARK: - Functions
    
    override func configureView() {
        super.configureView()

        addSubviews([starFilterStackView, recentFilterStackView, contentBorder])

        [starFilterLabel, starExpanMoreImageView].forEach {
            starFilterStackView.addArrangedSubview($0)
        }

        [recentFilterLabel, recentExpanMoreImageView].forEach {
            recentFilterStackView.addArrangedSubview($0)
        }

    }
    
    override func layoutView() {
        super.layoutView()
        
        contentBorder.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        recentFilterStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(self.snp.centerY)
        }
        recentExpanMoreImageView.snp.makeConstraints {
            $0.width.equalTo(recentExpanMoreImageView.snp.height)
        }
        
        starFilterStackView.snp.makeConstraints {
            $0.trailing.equalTo(recentFilterStackView.snp.leading).offset(-8)
            $0.centerY.equalTo(recentFilterStackView.snp.centerY)
        }
        starExpanMoreImageView.snp.makeConstraints {
            $0.width.equalTo(starExpanMoreImageView.snp.height)
        }
        
    }
}
