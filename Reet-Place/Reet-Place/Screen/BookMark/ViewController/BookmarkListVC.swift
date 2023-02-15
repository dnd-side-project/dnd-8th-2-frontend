//
//  BookmarkListVC.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/15.
//

import UIKit

import RxSwift
import RxCocoa

import Then
import SnapKit

class BookmarkListVC: BaseViewController {
    
    // MARK: - UI components
    
    let label = UILabel()
        .then {
            $0.text = "BookmarkListVC"
        }
    
    // MARK: - Variables and Properties
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalTo(view)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func layoutView() {
        super.layoutView()
    }
    
    // MARK: - Functions
    
    
}

