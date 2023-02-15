//
//  BookmarkVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import UIKit

import RxSwift
import RxCocoa

import Then
import SnapKit

class BookmarkVC: BaseViewController {
    
    // MARK: - UI components
    
    let label = UILabel()
        .then {
            $0.text = "BookmarkVC"
        }
    
    let allBookmarkBtn = AllBookmarkButton(count: 99)
    
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalTo(view)
        }
        
        view.addSubview(allBookmarkBtn)
        allBookmarkBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(96)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(76)
        }
        
        allBookmarkBtn.rx.tap
            .bind(onNext: {
                print("allBookmarkBtn Pressed!")
                let bookmarkListVC = BookmarkListVC()
                self.navigationController?.pushViewController(bookmarkListVC, animated: true)
            })
            .disposed(by: bag)
    }
    
    override func configureView() {
        super.configureView()
        
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Functions
    
}


// MARK: - Layout

extension BookmarkVC {
    
    private func configureLayout() {
        
    }
    
}
