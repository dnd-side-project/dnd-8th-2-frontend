//
//  ReetBottomSheet.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/25.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxGesture

class ReetBottomSheet: BaseViewController {
    
    enum SheetStyle {
        case h160
        case h185
        case h241
        case h420
        case h480
        case h600
        case h616
    }
    
    let dimmedView = UIView()
        .then {
            $0.backgroundColor = AssetColors.gray900.withAlphaComponent(0.7)
        }
    
    let bottomSheetView = UIView()
        .then {
            $0.backgroundColor = AssetColors.white
            $0.layer.cornerRadius = 16.0
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.clipsToBounds = true
        }
    
    let sheetBar = UIView()
        .then {
            $0.backgroundColor = AssetColors.gray300
            $0.isUserInteractionEnabled = false
        }
    
    
    // MARK: - Variables and Properties
    
    var sheetStyle: SheetStyle = .h160
    
    var sheetHeight: CGFloat {
        switch sheetStyle {
        case .h160:
            return 160.0
        case .h185:
            return 185.0
        case .h241:
            return 241.0
        case .h420:
            return 420.0
        case .h480:
            return 480.0
        case .h600:
            return 600.0
        case .h616:
            return 616.0
        }
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
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
    
    func showBottomSheet() {
        bottomSheetView.snp.updateConstraints {
            $0.height.equalTo(sheetHeight)
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
            self.dimmedView.alpha = 0.7
            
            self.view.layoutIfNeeded()
        }
    }
    
    func dismissBottomSheet() {
        bottomSheetView.snp.updateConstraints {
            $0.height.equalTo(0)
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        } completion: { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false)
            }
        }
    }
    
}


// MARK: - Configure

extension ReetBottomSheet {
    
    private func configureContentView() {
        view.backgroundColor = UIColor.clear
        
        view.addSubviews([dimmedView, bottomSheetView])
        bottomSheetView.addSubview(sheetBar)
        
        dimmedView.alpha = 0.0
        
        dimmedView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismissBottomSheet()
            })
            .disposed(by: bag)
        
        configureShadow()
    }
    
    private func configureShadow() {
        view.layer.shadowColor = CGColor(red: 23.0 / 255.0, green: 23.0 / 255.0, blue: 23.0 / 255.0, alpha: 1)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 16.0
        view.layer.shadowOffset = CGSize(width: 0, height: -2.0)
        view.layer.masksToBounds = false
    }
    
}


// MARK: - Layout

extension ReetBottomSheet {
    
    private func configureLayout() {
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        sheetBar.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(8)
            $0.width.equalTo(32)
            $0.height.equalTo(3)
        }
    }
    
}
