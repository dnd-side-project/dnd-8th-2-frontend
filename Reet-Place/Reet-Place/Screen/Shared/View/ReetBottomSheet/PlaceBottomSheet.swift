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

import NMapsMap

final class PlaceBottomSheet: BaseViewController {
    
    // MARK: - UI components
    
    private let dimmedView = UIView()
        .then {
            $0.backgroundColor = .clear
        }
    
    private let bottomSheetView = UIView()
        .then {
            $0.backgroundColor = AssetColors.white
            $0.layer.cornerRadius = 16.0
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.clipsToBounds = true
        }
    
    private let sheetBar = UIView()
        .then {
            $0.layer.cornerRadius = 1.5
            $0.layer.masksToBounds = true
            $0.backgroundColor = AssetColors.gray300
            $0.isUserInteractionEnabled = false
        }
    
    private let baseStackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 19.0
        }
    private let placeInformationStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.alignment = .center
            $0.spacing = 12.0
        }
    private let thumbnailImageView = UIImageView()
        .then {
            $0.image = AssetsImages.placeResultThumbnail
            
            $0.contentMode = .scaleAspectFill
            $0.layer.borderColor = AssetColors.gray300.cgColor
            $0.layer.cornerRadius = 4.0
            $0.layer.masksToBounds = true
        }
    private let placeInformationView = PlaceInformationView()
    private let linkButton = UIButton()
        .then {
            $0.setImage(AssetsImages.link?.withTintColor(AssetColors.gray500), for: .normal)
            $0.isUserInteractionEnabled = false
        }
    
    private let saveBookmarkButton = ReetButton(with: "SaveBookmark".localized,
                                                for: .outlined,
                                                left: AssetsImages.addFolder)
        .then {
            $0.isHidden = true
        }
    
    private let wishBookmarkButton = ReetButton(with: "BookmarkWishlist".localized,
                                                for: .primary,
                                                left: AssetsImages.starFolder)
        .then {
            $0.isHidden = true
        }
    
    private let doneBookmarkButton = ReetButton(with: "BookmarkHistory".localized,
                                                for: .secondary,
                                                left: AssetsImages.starFolder)
        .then {
            $0.isHidden = true
        }
    
    // MARK: - Variables and Properties
    
    private var bookmarkType: BookmarkType = .standard
    private var searchPlaceInfo: SearchPlaceListContent?
    private var bookmarkSummary: BookmarkSummaryModel?
    private var placeName: String = .empty
    private var marker: NMFMarker?
    private var isAuthenticated: Bool {
        return KeychainManager.shared.read(for: .accessToken) != nil
    }
    
    // MARK: - Life Cycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showPlaceBottomSheet()
    }
    
    override func configureView() {
        super.configureView()
        
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindDimmedView()
        bindButton()
    }
    
    // MARK: - Functions
    
    private func showPlaceBottomSheet() {
        bottomSheetView.snp.updateConstraints {
            $0.height.equalTo(185.0)
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func dismissPlaceBottomSheet() {
        updateMarkerIcon(isSelected: false)
        
        bottomSheetView.snp.updateConstraints {
            $0.height.equalTo(0)
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false)
            }
        }
    }
    
    private func updateMarkerIcon(isSelected: Bool) {
        var iconImage: UIImage?
        
        switch isSelected {
        case true:
            let markerExtendedStackView = MarkerExtendedStackView(placeName: placeName, markerState: bookmarkType.markerState)
            
            let renderer = UIGraphicsImageRenderer(bounds: markerExtendedStackView.getOwnBounds())
            let image = renderer.image { context in
                markerExtendedStackView.layer.render(in: context.cgContext)
            }
            iconImage = image
            
        case false:
            iconImage = MarkerType.round(bookmarkType.markerState).image
        }
        
        if let iconImage = iconImage {
            marker?.iconImage = NMFOverlayImage(image: iconImage)
        } else {
            print("iconImage insert failed")
        }
    }
    
    private func convertMarkerExtendedStackViewToImage(targetMarkerExtendedStackView: MarkerExtendedStackView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: targetMarkerExtendedStackView.getOwnBounds())
        let image = renderer.image { context in
            targetMarkerExtendedStackView.layer.render(in: context.cgContext)
        }
        
        return image
    }
    
    @objc private func goToLogin() {
        let loginVC = LoginVC()        
        loginVC.pushWithHidesReetPlaceTabBar()
    }
}

// MARK: - Configure

extension PlaceBottomSheet {
    
    /// 장소바텀시트에 표시될 정보 값 입력 및 마커 상태 업데이트
    func configurePlaceBottomSheet(placeInfo: SearchPlaceListContent, marker: NMFMarker?) {
        self.searchPlaceInfo = placeInfo
        self.placeName = placeInfo.name
        self.bookmarkType = BookmarkType(rawValue: placeInfo.type ?? .empty)
        self.marker = marker
        
        let category = PlaceCategoryList(rawValue: placeInfo.category).name
        if let thumbnailImage = placeInfo.thumbnailImage {
            thumbnailImageView.setImage(with: thumbnailImage, placeholder: AssetsImages.placeResultThumbnail)
        }
        placeInformationView.configurePlaceInfomation(
            placeName: placeInfo.name,
            address: placeInfo.roadAddress,
            category: category
        )
        bindLinkButton(url: placeInfo.url)
        configureButton()
        updateMarkerIcon(isSelected: true)
    }
    
    /// 지도로 보기에서 마커를 선택했을 때의 바텀시트를 구성합니다.
    /// - Parameters:
    ///   - bookmarkSummary: 지도의 북마크 요약 정보
    ///   - bookmarkType: 북마크 타입
    ///   - marker: 선택된 마커
    func configurePlaceBottomSheet(
        bookmarkSummary: BookmarkSummaryModel,
        bookmarkType: BookmarkType,
        marker: NMFMarker
    ) {
        self.bookmarkSummary = bookmarkSummary
        self.placeName = bookmarkSummary.name
        self.bookmarkType = bookmarkType
        self.marker = marker
        let category = PlaceCategoryList(rawValue: bookmarkSummary.category).name
        
        placeInformationView.configurePlaceInfomation(
            placeName: bookmarkSummary.name,
            address: bookmarkSummary.roadAddress,
            category: category
        )
        bindLinkButton(url: bookmarkSummary.url)
        configureButton()
        updateMarkerIcon(isSelected: true)
    }
    
    private func configureButton() {
        [saveBookmarkButton,
         wishBookmarkButton,
         doneBookmarkButton].forEach {
            $0.isHidden = true
        }
        
        switch bookmarkType {
        case .standard:
            saveBookmarkButton.isHidden = false
        case .want:
            wishBookmarkButton.isHidden = false
        case .gone:
            doneBookmarkButton.isHidden = false
        }
    }
    
    private func configureContentView() {
        view.backgroundColor = .clear
        
        view.layer.shadowColor = CGColor(red: 23.0 / 255.0, green: 23.0 / 255.0, blue: 23.0 / 255.0, alpha: 1)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 16.0
        view.layer.shadowOffset = CGSize(width: 0, height: -2.0)
        
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
}

// MARK: - Layout

extension PlaceBottomSheet {
    
    private func configureLayout() {
        // Add Subviews
        view.addSubviews([dimmedView,
                          bottomSheetView])
        bottomSheetView.addSubviews([sheetBar,
                                     baseStackView, linkButton])
        
        [thumbnailImageView,
         placeInformationView].forEach {
            placeInformationStackView.addArrangedSubview($0)
        }
        [placeInformationStackView,
         saveBookmarkButton,
         wishBookmarkButton,
         doneBookmarkButton].forEach {
            baseStackView.addArrangedSubview($0)
        }
        
        // Make Constraints
        dimmedView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        bottomSheetView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(0)
        }
        
        sheetBar.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(8)
            $0.width.equalTo(32)
            $0.height.equalTo(sheetBar.layer.cornerRadius * 2.0)
        }
        
        baseStackView.snp.makeConstraints {
            $0.top.equalTo(bottomSheetView.snp.top).offset(23.0)
            $0.horizontalEdges.equalTo(bottomSheetView).inset(20.0)
        }
        thumbnailImageView.snp.makeConstraints {
            $0.width.height.equalTo(56.0)
        }
        linkButton.snp.makeConstraints {
            $0.width.height.equalTo(20.0)
            $0.top.trailing.equalTo(placeInformationView)
        }
    }
    
}

// MARK: - Bind Input

extension PlaceBottomSheet {
    
    private func bindDimmedView() {
        dimmedView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.dismissPlaceBottomSheet()
            })
            .disposed(by: bag)
    }
    
    private func bindLinkButton(url: String) {
        placeInformationStackView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self,
                      let url = URL(string: url) else { return }
                
                let safariViewController = SFSafariViewController(url: url)
                safariViewController.preferredBarTintColor = AssetColors.white
                safariViewController.preferredControlTintColor = AssetColors.primary500
                self.present(safariViewController, animated: true)
            })
            .disposed(by: bag)
    }
    
    private func bindButton() {
        saveBookmarkButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self, let searchPlaceInfo else { return }
                
                if isAuthenticated {
                    let bottomSheetVC = BookmarkBottomSheetVC(isBookmarking: false)
                    bottomSheetVC.configureInitialData(with: searchPlaceInfo)
                    
                    bottomSheetVC.savedBookmarkType
                        .withUnretained(self)
                        .subscribe { owner, bookmarkType in
                            owner.bookmarkType = bookmarkType
                            owner.updateMarkerIcon(isSelected: true)
                            owner.configureButton()
                            owner.showToast(message: "BookmarkSaved".localized, bottomViewHeight: 157.0)
                        }
                        .disposed(by: bag)
                    
                    bottomSheetVC.modalPresentationStyle = .overFullScreen
                    self.present(bottomSheetVC, animated: true)
                } else {
                    self.showPopUp(popUpType: .goToLogin, 
                                   targetVC: self,
                                   confirmBtnAction: #selector(goToLogin))
                }
            })
            .disposed(by: bag)
        
        wishBookmarkButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                guard let bookmarkSummary = owner.bookmarkSummary else { return }
                let bottomSheetVC = BookmarkBottomSheetVC(isBookmarking: true)
                bottomSheetVC.configureSheetData(with: bookmarkSummary)
                bottomSheetVC.modalPresentationStyle = .overFullScreen
                
                owner.present(bottomSheetVC, animated: true)
            }
            .disposed(by: bag)
        
        doneBookmarkButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                guard let bookmarkSummary = owner.bookmarkSummary else { return }
                let bottomSheetVC = BookmarkBottomSheetVC(isBookmarking: true)
                bottomSheetVC.configureSheetData(with: bookmarkSummary)
                bottomSheetVC.modalPresentationStyle = .overFullScreen
                
                owner.present(bottomSheetVC, animated: true)
            }
            .disposed(by: bag)
    }
    
}
