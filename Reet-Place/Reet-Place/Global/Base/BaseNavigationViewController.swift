//
//  BaseNavigationViewController.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/16.
//

import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa


class BaseNavigationViewController: BaseViewController {
    
    override var title: String? {
        didSet {
            navigationBar.titleLabel.text = title
        }
    }
    
    var navigationBarStyle: NavigationBar.BarStyle {
        .default
    }
    
    var navigationBar: NavigationBar!
    
    override func configureView() {
        super.configureView()
        
        navigationBar = NavigationBar(style: navigationBarStyle, title: title)
        
        view.addSubview(navigationBar)
    }
    
    override func layoutView() {
        super.layoutView()
        
        navigationBar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        navigationBar.titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func bindInput() {
        super.bindInput()
        
        navigationBar.leftButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.backButtonTapped()
            })
            .disposed(by: bag)
        
        navigationBar.rightButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.backButtonTapped()
            })
            .disposed(by: bag)
    }
    
    func backButtonTapped() {
        guard let navC = navigationController else {
            dismiss(animated: true)
            return
        }
        
        navC.popViewController(animated: true)
    }
    
}
