//
//  PlaceBottomSheet.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/03/03.
//

import UIKit
import SafariServices

import SnapKit
import Then

import RxSwift
import RxGesture
import RxCocoa

class PlaceBottomSheet: ReetBottomSheet {
    
    // MARK: - UI components
    
    private let placeInformationView = PlaceInformationView()
    private let linkButton = UIButton()
        .then {
            $0.setImage(AssetsImages.link?.withTintColor(AssetColors.gray500), for: .normal)
        }
    
    private let saveBookmarkButton = ReetButton(with: "SaveBookmark".localized, for: .outlined, left: AssetsImages.addFolder)
    
    // MARK: - Variables and Properties
    
    var mock: BookmarkCardModel?
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configurePlaceBottomSheet()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindButton()
    }
    
}

// MARK: - Configure

extension PlaceBottomSheet {
    
    func configurePlaceBottomSheet() {
        sheetStyle = .h185
    }
    
    func configurePlaceInformation(placeInfo: BookmarkCardModel) {
        mock = placeInfo
        placeInformationView.configurePlaceInfomation(placeName: placeInfo.placeName, address: placeInfo.address, category: placeInfo.categoryName)
    }
    
}

// MARK: - Layout

extension PlaceBottomSheet {
    
    private func configureLayout() {
        view.addSubviews([placeInformationView, linkButton,
                         saveBookmarkButton])
        
        placeInformationView.snp.makeConstraints {
            $0.top.equalTo(bottomSheetView.snp.top).offset(23)
            $0.leading.equalTo(bottomSheetView.snp.leading).offset(20)
            $0.trailing.equalTo(bottomSheetView.snp.trailing).offset(-20)
        }
        linkButton.snp.makeConstraints {
            $0.width.height.equalTo(20.0)
            
            $0.top.trailing.equalTo(placeInformationView)
        }
        
        saveBookmarkButton.snp.makeConstraints {
            $0.top.equalTo(placeInformationView.snp.bottom).offset(19.0)
            $0.horizontalEdges.equalTo(placeInformationView)
        }
    }
    
}

extension PlaceBottomSheet {
    
    private func bindButton() {
        linkButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                
                guard let url = URL(string: self.mock?.relLink1 ?? .empty) else { return }
                let safariViewController = SFSafariViewController(url: url)
                safariViewController.preferredBarTintColor = AssetColors.white
                safariViewController.preferredControlTintColor = AssetColors.primary500
                self.present(safariViewController, animated: true)
            })
            .disposed(by: bag)
        
        saveBookmarkButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                
                let bottomSheetVC = BookmarkBottomSheetVC()
                guard let data = self.mock else { return }
                bottomSheetVC.configureSheetData(with: data)
                
                bottomSheetVC.modalPresentationStyle = .overFullScreen
                self.present(bottomSheetVC, animated: true)
            })
            .disposed(by: bag)
    }
    
}
