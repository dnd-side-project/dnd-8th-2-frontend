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
    
    let label = UILabel()
        .then {
            $0.text = "MyPageVC"
        }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalTo(view)
        }
    }
    
    // MARK: - Functions
}
