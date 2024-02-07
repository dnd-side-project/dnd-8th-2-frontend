//
//  HomeVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

import Then
import SnapKit

import NMapsMap
import CoreLocation

final class HomeVC: BaseViewController {
    
    // MARK: - UI components
    
    private let mapView = NMFMapView()
    
    private let searchTextField = UITextField()
        .then {
            $0.backgroundColor = .white
            $0.font = AssetFonts.body1.font
            $0.attributedPlaceholder = NSAttributedString(
                string: "SearchByDistrict".localized,
                attributes: [NSAttributedString.Key.foregroundColor: AssetColors.gray400]
            )
            $0.addLeftPadding(padding: 16)
            $0.rightViewMode = .whileEditing

            $0.layer.cornerRadius = 8
            $0.addShadow()
        }
    private let cancelButton = UIButton()
        .then {
            $0.setImage(AssetsImages.cancelContained, for: .normal)
            $0.isHidden = true
        }
    private let searchButton = UIButton()
        .then {
            $0.setImage(AssetsImages.search, for: .normal)
        }
    
    private let categoryFilterButton = ReetFAB(size: .round(.small), title: nil, image: .filter)
    private let placeCategoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        .then {
            $0.backgroundColor = .clear
            
            let layout = UICollectionViewFlowLayout()
                .then {
                    $0.scrollDirection = .horizontal
                    $0.minimumLineSpacing = 4.0
                    $0.minimumInteritemSpacing = 4.0
                    $0.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 20.0)
                    $0.estimatedItemSize = CGSize(width: 48.0, height: 32.0)
                    $0.itemSize = UICollectionViewFlowLayout.automaticSize
                }
            $0.collectionViewLayout = layout
            
            $0.allowsMultipleSelection = false
            $0.showsHorizontalScrollIndicator = false
            $0.clipsToBounds = true
            
            $0.register(PlaceCategoryChipCVC.self, forCellWithReuseIdentifier: PlaceCategoryChipCVC.className)
        }
    
    private let placeResultListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        .then {
            $0.isHidden = true
            
            $0.backgroundColor = .clear
            
            let layout = UICollectionViewFlowLayout()
                .then {
                    $0.scrollDirection = .horizontal
                    $0.minimumLineSpacing = 8.0
                    $0.minimumInteritemSpacing = 4.0
                    $0.sectionInset = UIEdgeInsets(top: 0.0, left: constants.SectionInset.padding, bottom: 0.0, right: constants.SectionInset.padding)
                    $0.estimatedItemSize = CGSize(width: constants.width, height: constants.height)
                    $0.itemSize = UICollectionViewFlowLayout.automaticSize
                }
            $0.collectionViewLayout = layout
            
            $0.showsHorizontalScrollIndicator = false
            $0.clipsToBounds = false
            
            $0.register(PlaceResultListCVC.self, forCellWithReuseIdentifier: PlaceResultListCVC.className)
        }
    
    private let currentPositionButton = ReetFAB(size: .round(.small), title: nil, image: .directionTool)
    
    // MARK: - Variables and Properties
    
    private let viewModel = HomeVM()
    
    private let locationManager = CLLocationManager()
    private var markerList: [String:NMFMarker] = [:]
    
    private enum Constants {
        enum PlaceResultListCollectionView {
            static let width: CGFloat = 240.0
            static let height: CGFloat = 80.0
            static let padding: CGFloat = 12.0
            
            enum SectionInset {
                static let padding: CGFloat = 20.0
            }
        }
    }
    private typealias constants = Constants.PlaceResultListCollectionView
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureMapView()
        configureLocationManager()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindCollectionView()
        bindButton()
        bindTextField()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        bindPlaceCategoryList()
        bindSearchPlaceListResult()
    }
    
    // MARK: - Functions
    
    private func presentPlaceBottomSheet(placeInfo: SearchPlaceListContent) {
        let marker = markerList[placeInfo.kakaoPID]
        
        if let location = marker?.position {
            mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: location.lat, lng: location.lng)))
        }
        
        let bottomSheetVC = PlaceBottomSheet()
        bottomSheetVC.configurePlaceBottomSheet(placeInfo: placeInfo,
                                                marker: marker)
        present(bottomSheetVC, animated: false)
    }
    
}

// MARK: - Configure

extension HomeVC {
    
    private func configureMapView() {
        mapView.touchDelegate = self
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
    }
    
    private func configureMapViewMarker(searchPlaceList: SearchPlaceListResponseModel) {
        // 기존 마커 표시 초기화
        markerList.forEach {
            $0.value.mapView = nil
        }
        markerList = [:]
        
        // 조회한 카테고리 목록들에 대한 마커 생성
        // 백그라운드 스레드
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else { return }
            
            searchPlaceList.contents.forEach { placeInfo in
                let marker = NMFMarker()
                marker.position = NMGLatLng(lat: Double(placeInfo.lat)!, lng: Double(placeInfo.lng)!)
                
                let bookmarkType = BookmarkType(rawValue: placeInfo.type ?? .empty)!
                marker.iconImage = NMFOverlayImage(image: MarkerType.round(bookmarkType.markerState).image)
                marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
                    self.presentPlaceBottomSheet(placeInfo: placeInfo)
                    return true
                }
                
                self.markerList[placeInfo.kakaoPID] = marker
            }
            
            // 메인 스레드
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                for marker in markerList {
                    marker.value.mapView = self.mapView
                }
            }
            
        } // End of Background Tasks
    }
    
}

// MARK: - Layout

extension HomeVC {
    
    private func configureLayout() {
        // Add Subviews
        view.addSubviews([mapView,
                          searchTextField, cancelButton, searchButton,
                          categoryFilterButton, placeCategoryCollectionView,
                          placeResultListCollectionView,
                          currentPositionButton])
        
        // Make Constraints
        mapView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        searchTextField.snp.makeConstraints {
            $0.height.equalTo(44.0)
            
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(mapView.snp.leading).offset(20.0)
            $0.trailing.equalTo(mapView.snp.trailing).offset(-20.0)
        }
        cancelButton.snp.makeConstraints {
            $0.width.height.equalTo(24.0)
            
            $0.centerY.equalTo(searchTextField)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-10.0)
        }
        searchButton.snp.makeConstraints {
            $0.width.height.equalTo(28.0)
            
            $0.centerY.equalTo(searchTextField)
            $0.trailing.equalTo(searchTextField.snp.trailing).inset(16.0)
        }
        
        categoryFilterButton.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(12.0)
            $0.leading.equalTo(searchTextField)
        }
        placeCategoryCollectionView.snp.makeConstraints {
            $0.height.equalTo(44.0)
            
            $0.centerY.equalTo(categoryFilterButton)
            $0.leading.equalTo(categoryFilterButton.snp.trailing).offset(4.0)
            $0.trailing.equalTo(mapView)
        }
        
        placeResultListCollectionView.snp.makeConstraints {
            $0.height.equalTo(constants.height)
            
            $0.leading.trailing.equalTo(mapView)
            $0.bottom.equalTo(mapView.snp.bottom).offset(-constants.padding)
        }
        
        currentPositionButton.snp.makeConstraints {
            $0.trailing.bottom.equalTo(mapView).offset(-constants.SectionInset.padding)
        }
    }
    
}

// MARK: - Input

extension HomeVC {
    
    private func bindCollectionView() {
        placeCategoryCollectionView.rx.modelSelected(PlaceCategoryList.self)
            .withUnretained(self)
            .bind(onNext: { owner, selectedCategory in
                owner.placeResultListCollectionView.scrollToTop()
                
                let latitude = owner.mapView.latitude.description
                let longitude = owner.mapView.longitude.description
                owner.viewModel.requestSearchPlaces(category: selectedCategory, 
                                                    latitude: latitude,
                                                    longitude: longitude)
            })
            .disposed(by: bag)
        
        placeCategoryCollectionView.rx.itemSelected
            .withUnretained(self)
            .bind(onNext: { owner, indexPath in
                owner.placeCategoryCollectionView.scrollToItem(at: indexPath, 
                                                               at: .centeredHorizontally,
                                                               animated: true)
            })
            .disposed(by: bag)
        
        placeResultListCollectionView.rx.modelSelected(SearchPlaceListContent.self)
            .withUnretained(self)
            .bind(onNext: { owner, placeInfo in
                owner.presentPlaceBottomSheet(placeInfo: placeInfo)
            })
            .disposed(by: bag)
        
        placeResultListCollectionView.rx.itemSelected
            .withUnretained(self)
            .bind(onNext: { owner, indexPath in
                owner.placeResultListCollectionView.scrollToItem(at: indexPath, 
                                                                 at: .centeredHorizontally,
                                                                 animated: true)
            })
            .disposed(by: bag)
    }
    
    private func bindButton() {
        searchButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.searchTextField.becomeFirstResponder()
            })
            .disposed(by: bag)
        
        cancelButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.searchTextField.text = .empty
                self.searchTextField.becomeFirstResponder()
            })
            .disposed(by: bag)
        
        categoryFilterButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                let categoryFilterBottomSheet = CategoryFilterBottomSheet()
                categoryFilterBottomSheet.modalPresentationStyle = .overFullScreen
                self.present(categoryFilterBottomSheet, animated: false)
            })
            .disposed(by: bag)
        
        currentPositionButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                
                switch locationManager.authorizationStatus {
                case .authorizedAlways, .authorizedWhenInUse:
                    print("위치 서비스 On 상태")
                    let currentPositionMode = mapView.positionMode
                    mapView.positionMode = currentPositionMode == .direction ? .disabled : .direction
                default:
                    print("위치 서비스 Off 상태")
                    locationManager.requestWhenInUseAuthorization()
                }
            })
            .disposed(by: bag)
    }
    
    private func bindTextField() {
        searchTextField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                let searchVC = SearchVC()
                searchVC.delegateSearchPlaceAction = self
                searchVC.pushWithHidesReetPlaceTabBar()
                
                self.searchTextField.resignFirstResponder()
            })
            .disposed(by: bag)
    }
    
}

// MARK: - Output

extension HomeVC {
    
    private func bindPlaceCategoryList() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<PlaceCategoryListDataSource> { _,
            collectionView,
            indexPath,
            categoryType in
            
            guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: PlaceCategoryChipCVC.className,
                                     for: indexPath) as? PlaceCategoryChipCVC else {
                fatalError("Cannot deqeue cells named PlaceCategoryChipCVC")
            }
            cell.configurePlaceCategoryChipCVC(placeCategory: categoryType)
            
            return cell
        }
        
        viewModel.output.placeCategoryDataSources
            .bind(to: placeCategoryCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    private func bindSearchPlaceListResult() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<PlaceResultListDataSource> { _,
            collectionView,
            indexPath,
            placeResult in
            
            guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: PlaceResultListCVC.className,
                                     for: indexPath) as? PlaceResultListCVC else {
                fatalError("Cannot deqeue cells named PlaceResultListCVC")
            }
            cell.configurePlaceResultListCVC(placeResultInfo: placeResult)
            
            return cell
        }
        
        viewModel.output.placeResultListDataSource
            .bind(to: placeResultListCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        viewModel.output.searchPlaceList
            .withUnretained(self)
            .subscribe(onNext: { owner, data in
                owner.configureMapViewMarker(searchPlaceList: data)
                
                if owner.placeResultListCollectionView.isHidden {
                    owner.placeResultListCollectionView.isHidden = false
                }
                
                var updateConstant: CGFloat = 0.0
                switch data.contents.count > 1 {
                case true:
                    updateConstant = constants.padding + constants.height + 16.0
                case false:
                    updateConstant = constants.SectionInset.padding
                }
                owner.currentPositionButton.snp.updateConstraints {
                    $0.bottom.equalTo(owner.mapView).offset(-updateConstant)
                }
                
                owner.placeResultListCollectionView.reloadData()
            })
            .disposed(by: bag)
    }
    
}

// MARK: - NaverMap Delegate

extension HomeVC: NMFMapViewTouchDelegate {
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print(latlng)
    }
    
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        return false
    }
    
}

// MARK: - CLLocationManager Delegate

extension HomeVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let coordinate = location.coordinate
            print(coordinate)
            manager.stopUpdatingLocation()
        } else {
            print("get current coordinate error")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("get location failed", error)
    }
    
}

// MARK: - SearchPlace Action Delegate

extension HomeVC: SearchPlaceAction {
    
    func getCurrentLocationCoordinate() -> CLLocationCoordinate2D? {
        return locationManager.location?.coordinate
    }
    
}
