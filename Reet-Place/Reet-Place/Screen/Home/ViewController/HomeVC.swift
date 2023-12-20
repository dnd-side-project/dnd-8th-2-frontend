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

class HomeVC: BaseViewController {
    
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
            
            $0.showsHorizontalScrollIndicator = false
            $0.clipsToBounds = true
            
            $0.register(PlaceCategoryChipCVC.self, forCellWithReuseIdentifier: PlaceCategoryChipCVC.className)
        }
    
    private let currentPositionButton = ReetFAB(size: .round(.small), title: nil, image: .directionTool)
    
    // MARK: - Variables and Properties
    
    private let viewModel = HomeVM()
    
    private let locationManager = CLLocationManager()
    private var markerList: [NMFMarker] = []
    
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
        bindSearchPlacesResult()
    }
    
    // MARK: - Functions
}

// MARK: - Configure

extension HomeVC {
    
    private func configureMapView() {
        mapView.touchDelegate = self
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
    }
    
    private func configureSearchPlacesResult(searchPlaceList: SearchPlaceListResponseModel) {
        // 기존 마커 표시 초기화
        markerList.forEach {
            $0.mapView = nil
        }
        markerList = []
        
        // 조회한 카테고리 목록들에 대한 마커 생성
        // 백그라운드 스레드
        DispatchQueue.global(qos: .default).async {
            searchPlaceList.contents.forEach { placeInfo in
                let marker = NMFMarker()
                marker.position = NMGLatLng(lat: Double(placeInfo.lat)!, lng: Double(placeInfo.lng)!)
                
                let bookmarkType = BookmarkType(rawValue: placeInfo.type ?? .empty)!
                marker.iconImage = NMFOverlayImage(image: MarkerType.round(bookmarkType.markerState).image)
                marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
                    let bottomSheetVC = PlaceBottomSheet()
                    bottomSheetVC.modalPresentationStyle = .custom
                    bottomSheetVC.modalPresentationStyle = .overFullScreen
                    
                    bottomSheetVC.configurePlaceBottomSheet(placeName: placeInfo.name,
                                                            address: placeInfo.roadAddress,
                                                            category: placeInfo.category,
                                                            urlLink: placeInfo.url,
                                                            bookmarkType: bookmarkType,
                                                            marker: marker)
                    
                    self.present(bottomSheetVC, animated: false)
                    
                    return true
                }
                
                self.markerList.append(marker)
            }

            // 메인 스레드
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                for marker in markerList {
                    marker.mapView = self.mapView
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
        
        currentPositionButton.snp.makeConstraints {
            $0.trailing.bottom.equalTo(mapView).offset(-20.0)
        }
    }
    
}

// MARK: - Input

extension HomeVC {
    
    private func bindCollectionView() {
        placeCategoryCollectionView.rx.modelSelected(PlaceCategoryList.self)
            .withUnretained(self)
            .bind(onNext: { owner, category in
                print(category)
            })
            .disposed(by: bag)
        
        placeCategoryCollectionView.rx.itemSelected
            .withUnretained(self)
            .bind(onNext: { owner, indexPath in
                // TODO: - 카테고리 버튼 연결
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
                case .authorizedAlways,
                    .authorizedWhenInUse:
                    print("위치 서비스 On 상태")
                    locationManager.requestLocation()
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
            cell.delegate = self
            
            return cell
        }
        
        viewModel.output.placeCategoryDataSources
            .bind(to: placeCategoryCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    private func bindSearchPlacesResult() {
        viewModel.output.searchPlaceList
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.configureSearchPlacesResult(searchPlaceList: data)
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
            if let coordinate = locationManager.location?.coordinate {
                print(coordinate)
                mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude))) // TODO: - 현재위치 조회 오류(미국 쿠퍼티노로 조회) 문제 수정
            } else {
                print("get current coordinate error")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("get location failed", error)
    }
    
}

// MARK: - CategoryChipCVC Action Delegate

extension HomeVC: CategoryChipCVCAction {
    
    func tapCategoryChip(selectedCategory: PlaceCategoryList) {
        let latitude = mapView.latitude.description
        let longitude = mapView.longitude.description
        
        viewModel.requestSearchPlaces(targetSearchPlace: SearchPlaceListRequestModel(lat: latitude, lng: longitude, category: selectedCategory.parameterPlace, subCategory: selectedCategory.parameterSubCategoryList))
    }
    
}

// MARK: - SearchPlace Action Delegate

extension HomeVC: SearchPlaceAction {
    
    func getCurrentLocationCoordinate() -> CLLocationCoordinate2D? {
        return locationManager.location?.coordinate
    }
    
}
