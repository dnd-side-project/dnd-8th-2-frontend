//
//  DefaultCategoryTVC.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/16.
//

import UIKit

import SnapKit
import Then

class DefaultCategoryTVC: BaseTableViewCell {
    
    // MARK: - UI components
    
    let baseStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 8.0
            $0.distribution = .fill
            $0.alignment = .center
        }
    let titleLabel = BaseAttributedLabel(font: .subtitle2,
                               text: nil,
                               alignment: .left,
                               color: AssetColors.black)
        .then {
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }
    let rightImageView = UIImageView(image: AssetsImages.chevronRight52)
        .then {
            $0.contentMode = .scaleAspectFit
        }
    
    // MARK: - Variables and Properties
    
    static let defaultHeight: CGFloat = 56.0
    
    let defaultHorizontalOffset: CGFloat = 20.0
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = .empty
    }
    
}

// MARK: - Configure

extension DefaultCategoryTVC {
    
    /// DefaultCategoryTVC 정보을 입력
    func configureDefaultCategoryTVC(myPageMenuType: MyPageMenu) {
        titleLabel.text = myPageMenuType.description
        titleLabel.textColor = myPageMenuType.foregroundColor
    }
    
    private func configureContentView() {
        let selectedView = UIView()
        selectedView.backgroundColor = AssetColors.gray100
        selectedBackgroundView = selectedView
        
        backgroundColor = AssetColors.white
    }
    
}

// MARK: - Layout

extension DefaultCategoryTVC {
    
    private func configureLayout() {
        contentView.addSubviews([baseStackView])
        baseStackView.addArrangedSubview(titleLabel)
        baseStackView.addArrangedSubview(rightImageView)
        
        baseStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(defaultHorizontalOffset)
            $0.trailing.equalToSuperview()
        }
        rightImageView.snp.makeConstraints {
            $0.width.height.equalTo(52.0)
        }
    }
    
}
