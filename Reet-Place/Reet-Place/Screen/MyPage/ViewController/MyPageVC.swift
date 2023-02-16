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
        "MyPageDefault"
    }
    
    private let viewModel = MyPageViewModel()
    
    var loginVC: LoginVC?
    
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
                
                owner.loginVC = LoginVC()
                owner.embed(with: owner.loginVC!)
            })
            .disposed(by: bag)
    }
    
    // MARK: - Functions
}
