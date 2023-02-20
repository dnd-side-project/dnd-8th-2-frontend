//
//  BookmarkAllVC.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/17.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit
import Then

class BookmarkAllVC: BaseNavigationViewController {
    
    // MARK: - UI components
    
    private let label = UILabel()
        .then {
            $0.text = "BookmarkAllVC"
        }
    
    override var alias: String {
        "BookmarkAll"
    }
    
    
    // MARK: - Variables and Properties
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func configureView() {
        super.configureView()
        
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Functions
    
    
}


// MARK: - Configure

extension BookmarkAllVC {
    
    private func configureContentView() {
        view.addSubview(label)
        
        title = "전체보기"
        navigationBar.style = .left
    }
    
}


// MARK: - Layout

extension BookmarkAllVC {
    
    private func configureLayout() {
        label.snp.makeConstraints {
            $0.center.equalTo(view)
        }
    }
    
}
