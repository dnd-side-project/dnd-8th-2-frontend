//
//  MyPageVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import UIKit

import RxSwift
import RxCocoa

import Then
import SnapKit

class MyPageVC: BaseViewController {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    override var alias: String {
        "MyPageTab"
    }
    
    private let viewModel = MyPageViewModel()
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
    }
    
    override func layoutView() {
        super.layoutView()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        viewModel.output.isValidAuthToken
            .withUnretained(self)
            .bind(onNext: { owner, isValid in
                if isValid {
                    print("TODO: SHOW USER INFO")
                    return
                }
                
                let loginVC = LoginVC()
                let navC = UINavigationController(rootViewController: loginVC)
                navC.navigationBar.isHidden = true
                owner.embed(with: navC)
            })
            .disposed(by: bag)
    }
    
    // MARK: - Functions
}
