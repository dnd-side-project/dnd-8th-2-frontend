//
//  CategoryFilterCVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/28.
//

import UIKit

import Then
import SnapKit

import RxSwift
import RxCocoa

class CategoryFilterCVC: BaseCollectionViewCell {
    
    // MARK: - UI components
    
    private let categoryFilterButton = ReetFAB(size: .round(.small), title: nil, image: .filter)
    
    // MARK: - Variables and Properties
    
    private var bag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureContentView()
        bindButton()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Functions
}

// MARK: - Configure

extension CategoryFilterCVC {
    
    func configureContentView() {
        _ = contentView
            .then {
                $0.backgroundColor = .clear
                $0.clipsToBounds = false
                $0.layer.cornerRadius = contentView.frame.height / 2.0
            }
    }
    
}

// MARK: - Layout

extension CategoryFilterCVC {
    
    private func configureLayout() {
        contentView.addSubviews([categoryFilterButton])
        
        categoryFilterButton.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }
    
}

// MARK: - Input

extension CategoryFilterCVC {
    
    private func bindButton() {
        categoryFilterButton.rx.tap
            .asDriver()
            .drive(onNext: {
                print("called filter button", self.findViewController()?.navigationController)
            })
            .disposed(by: bag)
    }
    
}
