//
//  TabBarView.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/24.
//

import UIKit

import Then
import SnapKit

class TabBarView: BaseView {
    
    // MARK: - UI components
    
    private let borderView = BaseView()
        .then {
            $0.backgroundColor = AssetColors.black
        }
    
    let tabBarStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.spacing = .zero
        }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Functions
}

// MARK: - Configure

extension TabBarView {}

// MARK: - Layout

extension TabBarView {
    
    private func configureLayout() {
        addSubviews([borderView,
                    tabBarStackView])
        
        borderView.snp.makeConstraints {
            $0.height.equalTo(1)
            
            $0.top.horizontalEdges.equalTo(self)
        }
        tabBarStackView.snp.makeConstraints {
            $0.height.equalTo(50)
            
            $0.top.equalTo(borderView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(self)
        }
    }
    
}
