//
//  ReetMenuTabBarView.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/05/03.
//

import UIKit

import RxSwift
import RxCocoa

import Then
import SnapKit

class ReetMenuTabBarView: BaseView {
    
    // MARK: - UI components
    
    lazy var menuBarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        .then {
            $0.backgroundColor = .white
            $0.showsHorizontalScrollIndicator = false
            $0.allowsMultipleSelection = false
            $0.register(ReetMenuTarBarCVC.self, forCellWithReuseIdentifier: ReetMenuTarBarCVC.className)
        }
    
    // MARK: - Variables and Properties
    
    private var bag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        bindMenuBarCollectionView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configreLayout()
    }
    
    // MARK: - Functions
    
    /// 선택되어 있는 CollectionView Item 위치(IndexPath) 지정
    func setTabPosition(indexPath: IndexPath) {
        menuBarCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
    }
    
    /// menuCollectionView의 left inset 값을 포함하여 가장 왼쪽 탭으로 스크롤
    func scrollToStartTab() {
        menuBarCollectionView.scrollToTop()
    }
    
    /// menuCollectionView의 right inset 값을 포함하여 가장 오른쪽 탭으로 스크롤
    func scrollToEndTab(rightInset: CGFloat) {
        menuBarCollectionView.scrollToHorizontalOffset(offset: menuBarCollectionView.bottomOffset + rightInset)
    }
    
}

// MARK: - Configure

extension ReetMenuTabBarView {
    
    /// MenuBarCollectionView의 좌우 inset 값을 디자인에 따라 개별 설정
    func configureMenuBarCollectionView(customSectionInset: UIEdgeInsets) {
        let layout = UICollectionViewFlowLayout()
            .then {
                $0.scrollDirection = .horizontal
                $0.minimumLineSpacing = 0.0
                $0.minimumInteritemSpacing = 0.0
                $0.sectionInset = customSectionInset
                $0.estimatedItemSize = CGSize(width: 20.0, height: 24.0)
                $0.itemSize = UICollectionViewFlowLayout.automaticSize
            }
        menuBarCollectionView.collectionViewLayout = layout
    }
    
}

// MARK: - Layout

extension ReetMenuTabBarView {
    
    private func configreLayout() {
        addSubview(menuBarCollectionView)
        
        menuBarCollectionView.snp.makeConstraints {
            $0.height.equalTo(32.0)
            
            $0.edges.equalTo(self)
        }
    }
    
}

// MARK: - Input

extension ReetMenuTabBarView {
    
    private func bindMenuBarCollectionView() {
        menuBarCollectionView.rx.itemSelected
            .withUnretained(self)
            .bind(onNext: { owner, indexPath in
                guard let cell = owner.menuBarCollectionView.cellForItem(at: indexPath)
                as? ReetMenuTarBarCVC else { return }
                cell.isSelected = true
            })
            .disposed(by: bag)
        
        menuBarCollectionView.rx.itemDeselected
            .withUnretained(self)
            .bind(onNext: { owner, indexPath in
                guard let cell = owner.menuBarCollectionView.cellForItem(at: indexPath)
                as? ReetMenuTarBarCVC else { return }
                cell.isSelected = false
            })
            .disposed(by: bag)
    }
    
}
