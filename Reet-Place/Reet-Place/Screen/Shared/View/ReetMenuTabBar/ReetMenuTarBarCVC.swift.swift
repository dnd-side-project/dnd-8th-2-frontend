//
//  ReetMenuTarBarCVC.swift.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/05/03.
//

import UIKit

import Then
import SnapKit

import RxSwift
import RxCocoa

class ReetMenuTarBarCVC: BaseCollectionViewCell {
    
    // MARK: - UI components
    
    let tabButton = ReetTabButton(with: .empty, style: .normal)
    private let positionBarView = UIView()
        .then {
            $0.backgroundColor = AssetColors.primary500
            $0.roundCornersOnlyTop(radius: 1.0)
            $0.isHidden = true
        }
    
    // MARK: - Variables and Properties
    
    private var bag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Override
    
    override var isHighlighted: Bool {
        didSet {
            tabButton.isHighlighted = isHighlighted
        }
    }
    
    override var isSelected: Bool {
        didSet {
            tabButton.isSelected = isSelected
            positionBarView.isHidden = isSelected ? false : true
        }
    }
    
    // MARK: - Functions
}

// MARK: - Configure

extension ReetMenuTarBarCVC {
    
    /// 탭바 아이템을 초기화하는 함수
    func configureReetMenuTarBarCVC(tabPlaceCategory: TabPlaceCategoryList) {
        tabButton.configureButton(with: tabPlaceCategory.description, for: .normal)
    }
    
}

// MARK: - Layout

extension ReetMenuTarBarCVC {
    
    private func configureLayout() {
        contentView.addSubviews([tabButton,
                                 positionBarView])
        
        tabButton.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
        positionBarView.snp.makeConstraints {
            $0.height.equalTo(positionBarView.layer.cornerRadius * 2.0)
            
            $0.horizontalEdges.bottom.equalTo(tabButton)
        }
    }
    
}
