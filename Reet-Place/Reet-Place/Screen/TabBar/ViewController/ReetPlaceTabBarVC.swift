//
//  ReetPlaceTabBarVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/24.
//

import UIKit

import Then
import SnapKit

import RxSwift
import RxCocoa

class ReetPlaceTabBarVC: BaseViewController {
    
    // MARK: - UI components
    
    private let tabBarView = TabBarView()
    
    // MARK: - Variables and Properties
    
    private let itemList = TabBarItem.allCases
    private var vcList: [BaseNavigationController] = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setStartTab(itemType: .home)
    }
    
    override func configureView() {
        super.configureView()
        
        configureTabBarView()
        configureVCList()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Functions
    
    /// Reet 탭바 중 특정 타입의 아이템 탭을 활성화(선택상태) 하는 함수
    func activeTabBarItem(targetItemType: TabBarItem) {
        // Set button status
        tabBarView.tabBarStackView.arrangedSubviews.forEach {
            guard let subButton = $0 as? ReetTabBarItemButton else { return }
            let curButtonType = subButton.itemType
            
            let isSelected = curButtonType == targetItemType ? true : false
            subButton.setButtonStatus(isSelected: isSelected)
        }
        
        // Set viewController by selected tabBarItem type
        for index in 0..<vcList.count {
            let targetVC = vcList[index]
            if index == targetItemType.index {
                embed(with: targetVC)
                targetVC.view.snp.makeConstraints {
                    $0.top.horizontalEdges.equalTo(view)
                    $0.bottom.equalTo(tabBarView.snp.top)
                }
            } else {
                remove(of: targetVC)
            }
        }
    }
    
    /// TabBar에 있는 특정 탭의 ViewController 인스턴스를 반환
    func getTabInstance(tabType: TabBarItem) -> BaseNavigationController? {
        for index in 0..<vcList.count {
            if index == tabType.index {
                return vcList[index]
            }
        }
        
        return nil
    }
    
    private func setStartTab(itemType: TabBarItem) {
        activeTabBarItem(targetItemType: itemType)
    }
    
}

// MARK: - Configure

extension ReetPlaceTabBarVC {
    
    private func configureVCList() {
        itemList.forEach {
            vcList.append(BaseNavigationController(rootViewController: $0.createTabBarItemVC()))
        }
    }
    
    private func configureTabBarView() {
        itemList.forEach {
            let button = ReetTabBarItemButton(for: $0)
            tabBarView.tabBarStackView.addArrangedSubview(button)
            
            button.rx.tap
                .asDriver()
                .drive(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.activeTabBarItem(targetItemType: button.itemType)
                })
                .disposed(by: bag)
        }
    }
    
}

// MARK: - Layout

extension ReetPlaceTabBarVC {
    
    private func configureLayout() {
        view.addSubviews([tabBarView])
        
        tabBarView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}
