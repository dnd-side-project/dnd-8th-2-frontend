//
//  BookmarkHistoryVC.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/18.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit
import Then

class BookmarkHistoryVC: BaseNavigationViewController {
    
    // MARK: - UI components
    
    private let label = UILabel()
        .then {
            $0.text = "BookmarkHistoryVC"
        }
    
    override var alias: String {
        "BookmarkHistory"
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

extension BookmarkHistoryVC {
    
    private func configureContentView() {
        view.addSubview(label)
        
        title = "다녀왔어요"
        navigationBar.style = .left
    }
    
}


// MARK: - Layout

extension BookmarkHistoryVC {
    
    private func configureLayout() {
        label.snp.makeConstraints {
            $0.center.equalTo(view)
        }
    }
    
}
