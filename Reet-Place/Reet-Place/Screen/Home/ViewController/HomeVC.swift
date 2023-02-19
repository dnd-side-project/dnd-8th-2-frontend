//
//  HomeVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import UIKit

import RxSwift
import RxCocoa

import Then
import SnapKit

import NMapsMap

class HomeVC: BaseViewController {
    
    // MARK: - UI components
    
    private let mapView = NMFMapView()
    
    private let searchTextField = UITextField()
        .then {
            $0.backgroundColor = .white
            $0.font = .body1
            $0.attributedPlaceholder = NSAttributedString(
                string: "시/군/구로 검색",
                attributes: [NSAttributedString.Key.foregroundColor: AssetColors.gray500]
            )
            $0.addLeftPadding(padding: 16)
            $0.layer.cornerRadius = 8
        }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Functions
}

// MARK: - Layout

extension HomeVC {
    
    private func configureLayout() {
        view.addSubviews([mapView,
                         searchTextField])
        
        
        mapView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        searchTextField.snp.makeConstraints {
            $0.height.equalTo(44)
            
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(mapView.snp.left).offset(20)
            $0.right.equalTo(mapView.snp.right).inset(20)
        }
    }
    
}
