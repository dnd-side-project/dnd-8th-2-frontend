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
        "MyPageView"
    }
    
    private let viewModel = LoginViewModel()
    
    var loginVC: LoginVC?
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        guard let authToken = viewModel.output.authToken.value else {
            // TODO: JWT Expired Check
            
            loginVC = LoginVC()
            embed(with: loginVC!)
            
            return
        }
        
        // TODO: Show User Info
        print(authToken)
    }
    
    override func layoutView() {
        super.layoutView()
    }
    
    // MARK: - Functions
}
