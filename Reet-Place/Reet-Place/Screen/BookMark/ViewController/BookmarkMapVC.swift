//
//  BookmarkMapVC.swift
//  Reet-Place
//
//  Created by 김태현 on 12/13/23.
//

import UIKit

import RxSwift
import RxCocoa

import Then
import SnapKit

import NMapsMap

final class BookmarkMapVC: BaseNavigationViewController {
    
    // MARK: - UI components
    
    private let mapView: NMFMapView = .init()
    
    
    // MARK: - Variables and Properties
    
    private let viewModel: BookmarkMapVM = .init()
    private let bookmarkType: BookmarkSearchType
    private var markers: [NMFMarker] = .init()
    
    
    // MARK: - Initialize
    
    init(bookmarkType: BookmarkSearchType) {
        self.bookmarkType = bookmarkType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getBookmarkSummaries(type: bookmarkType)
    }
    
    override func configureView() {
        super.configureView()
        
        configureInnerView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        bindSummaries()
    }
    
    // MARK: - Functions
    
    private func configureMarkers(from summaries: [BookmarkSummaryModel]) {
        summaries.forEach { summary in
            guard let bookmarkType = BookmarkType(rawValue: summary.type) else { return }
            
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: summary.lat, lng: summary.lng)
            marker.iconImage = NMFOverlayImage(image: MarkerType.round(bookmarkType.markerState).image)
            
            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                guard let self else { return true }
                
                let bottomSheetVC = PlaceBottomSheet()
                bottomSheetVC.modalPresentationStyle = .overFullScreen
                bottomSheetVC.configurePlaceBottomSheet(
                    bookmarkSummary: summary,
                    bookmarkType: bookmarkType,
                    marker: marker
                )
                
                self.present(bottomSheetVC, animated: true)
                
                return true
            }
            
            marker.mapView = mapView
            markers.append(marker)
        }
        
        moveCameraForFitMakers()
    }
    
    /// 마커가 모두 보이도록 카메라를 이동함.
    private func moveCameraForFitMakers() {
        guard let firstMarker = markers.first else { return }
        let firstPosition = NMGLatLng(lat: firstMarker.position.lat, lng: firstMarker.position.lng)
        var markersBounds = NMGLatLngBounds(southWest: firstPosition, northEast: firstPosition)
        
        markers.forEach { marker in
            markersBounds = markersBounds.expand(toPoint: marker.position)
        }
        
        mapView.moveCamera(NMFCameraUpdate(fit: markersBounds, padding: 50.0))
    }
    
}


// MARK: - Configure

extension BookmarkMapVC {
    
    private func configureInnerView() {
        title = bookmarkType.title
        navigationBar.style = .right
        mapView.minZoomLevel = 5.0
        mapView.maxZoomLevel = 18.0
        mapView.extent = NMGLatLngBounds(
            southWestLat: 31.43,
            southWestLng: 122.37,
            northEastLat: 44.35,
            northEastLng: 132
        )
        
        view.addSubviews([mapView])
    }
    
}


// MARK: - Layout

extension BookmarkMapVC {
    
    private func configureLayout() {
        mapView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.bottom.trailing.equalTo(view)
        }
    }
    
}

// MARK: - Bind

extension BookmarkMapVC {
    
    private func bindSummaries() {
        viewModel.output.bookmarkSummaries
            .withUnretained(self)
            .subscribe { owner, summaries in
                owner.configureMarkers(from: summaries)
            }
            .disposed(by: bag)
    }
    
}
