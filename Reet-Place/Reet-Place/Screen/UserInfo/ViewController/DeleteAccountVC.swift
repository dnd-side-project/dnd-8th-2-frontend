//
//  DeleteAccountVC.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/04/24.
//

import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

class DeleteAccountVC: BaseNavigationViewController {
    
    // MARK: - UI components
    
    
    // MARK: - Variables and Properties
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func configureView() {
        super.configureView()
        
        configureNaviBar()
        configureDeleteAccount()
    }
    
    override func layoutView() {
        super.layoutView()
        
        
    }
    
    override func bindInput() {
        super.bindInput()
        
        
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        
    }
    
    // MARK: - Functions
    
}


// MARK: - Configure

extension DeleteAccountVC {
    
    private func configureNaviBar() {
        navigationBar.style = .left
        title = "탈퇴하기"
    }
    
    private func configureDeleteAccount() {
        
    }
    
}
