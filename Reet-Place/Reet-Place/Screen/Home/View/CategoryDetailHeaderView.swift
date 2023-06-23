//
//  CategoryDetailHeaderView.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/06/14.
//

import UIKit

import Then
import SnapKit

class CategoryDetailHeaderView: UICollectionReusableView {
    
    // MARK: - UI components
    
    private let titleLabel = UILabel()
        .then {
            $0.textColor = AssetColors.gray500
            $0.font = AssetFonts.body2.font
            $0.textAlignment = .left
        }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Function
}

// MARK: - Configure

extension CategoryDetailHeaderView {
    
    /// 세부 카테고리의 하위항목에 대한 제목을 설정하는 함수
    func configureHeaderView(title: String) {
        titleLabel.text = title
    }
    
}

// MARK: - Layout

extension CategoryDetailHeaderView {
    
    private func configureLayout() {
        addSubviews([titleLabel])
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
