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

class HomeVC: BaseViewController {
    
    // MARK: - UI components
    
    private let mapView = NMFMapView()
    
    private let searchTextField = UITextField()
        .then {
            $0.backgroundColor = .white
            $0.font = AssetFonts.body1.font
            $0.attributedPlaceholder = NSAttributedString(
                string: "SearchByDistrict".localized,
                attributes: [NSAttributedString.Key.foregroundColor: AssetColors.gray500]
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
    
    private let placeCategoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        .then {
            $0.backgroundColor = .clear
            
            let layout = UICollectionViewFlowLayout()
                .then {
                    $0.scrollDirection = .horizontal
                    $0.minimumLineSpacing = 4.0
                    $0.minimumInteritemSpacing = 4.0
                    $0.sectionInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
                    $0.estimatedItemSize = CGSize(width: 48.0, height: 32.0)
                    $0.itemSize = UICollectionViewFlowLayout.automaticSize
                }
            $0.collectionViewLayout = layout
            
            $0.showsHorizontalScrollIndicator = false
            $0.clipsToBounds = false
            
            $0.register(CategoryFilterCVC.self, forCellWithReuseIdentifier: CategoryFilterCVC.className)
            $0.register(CategoryChipCVC.self, forCellWithReuseIdentifier: CategoryChipCVC.className)
        }
    
    private let currentPositionButton = ReetFAB(size: .round(.small), title: nil, image: .directionTool)
    
    // MARK: - Variables and Properties
    
    private let viewmodel = HomeVM()
    
    // dummy data
    // TODO: - DummyData 지우기
    private let viewModel: BookmarkCardListVM = BookmarkCardListVM()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureView() {
        super.configureView()
        
        configureMapView()
        configureSearchTextField()
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
    }
    
    // MARK: - Functions
    
}

// MARK: - Configure

extension HomeVC {
    
    private func configureMapView() {
        mapView.touchDelegate = self
        
        // 더미 마커값 생성
        // 네이버 본사, 서울ICT이노베이션
        [NMGLatLng(lat: 37.35838205147338, lng: 127.1052659318825),
         NMGLatLng(lat:37.5453577, lng:126.9525465)].forEach {
            let marker = NMFMarker()
            marker.position = $0 as! NMGLatLng
            marker.mapView = mapView
            
            let image = NMFOverlayImage(name: "MarkerExtendedWishlist")
            marker.iconImage = image
            
            marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
                let bottemSheet = PlaceBottomSheet()
                bottemSheet.modalPresentationStyle = .overFullScreen
                self.present(bottemSheet, animated: true)
                
                return true
            }
            
            viewModel.getAllList()
            
            // 서울ICT이노베이션 근처 장소 2곳
            [NMGLatLng(lat: 37.54349189922267, lng: 126.9482621178211),
             NMGLatLng(lat: 37.54196065990934, lng: 126.9485339154298)].forEach {
                let marker = NMFMarker()
                marker.position = $0 as! NMGLatLng
                marker.mapView = mapView
                
                let image = NMFOverlayImage(name: "MarkerRoundDefault")
                marker.iconImage = image
                
                marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
                    let bottomSheetVC = PlaceBottomSheet()
                    let cardInfo = self.viewModel.output.cardList.value[1]
                    bottomSheetVC.configurePlaceInformation(placeInfo: cardInfo)
                    
                    bottomSheetVC.modalPresentationStyle = .overFullScreen
                    self.present(bottomSheetVC, animated: true)
                    
                    return true
                }
            }
            
            // 서울ICT이노베이션 근처 둥록한 장소 1곳
            [NMGLatLng(lat: 37.54388888223204, lng: 126.9536265356963)].forEach {
               let marker = NMFMarker()
                marker.position = $0 as! NMGLatLng
               marker.mapView = mapView
               
               let image = NMFOverlayImage(name: "MarkerRoundDidVisit")
               marker.iconImage = image
               
               marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
                   let bottomSheetVC = PlaceBottomSheet()
                   bottomSheetVC.modalPresentationStyle = .overFullScreen
                   self.present(bottomSheetVC, animated: true)
                   
                   return true
               }
           }
                
        }
    }
    
    private func configureSearchTextField() {
        let rightPaddingView = UIView()
        rightPaddingView.snp.makeConstraints {
            $0.width.equalTo(16.0 + 28.0 + 10.0 + 20.0)
        }
        
        _ = searchTextField
            .then {
                $0.rightView = rightPaddingView
                $0.rightViewMode = .always
            }
    }
    
}

// MARK: - Layout

extension HomeVC {
    
    private func configureLayout() {
        view.addSubviews([mapView,
                         searchTextField, cancelButton, searchButton,
                          placeCategoryCollectionView,
                         currentPositionButton])
        
        
        mapView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        searchTextField.snp.makeConstraints {
            $0.height.equalTo(44)
            
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
        
        placeCategoryCollectionView.snp.makeConstraints {
            $0.height.equalTo(44.0)
            
            $0.top.equalTo(searchTextField.snp.bottom).offset(12.0)
            $0.horizontalEdges.equalTo(mapView)
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
                print("TODO: - Search Place API to be call")
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
        
        currentPositionButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                
                // 서울 프론트원 좌표
                self.mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat:37.5453577, lng:126.9525465)))
            })
            .disposed(by: bag)
    }
    
    private func bindTextField() {
        searchTextField.rx.text
            .changed
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .empty)
            .drive(onNext: { [weak self] text in
                guard let self = self,
                let changedText = text else { return }
                
                self.cancelButton.isHidden = changedText.count > 0 ? false : true
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
            
            switch categoryType {
            case .filter:
                guard let cell = collectionView
                    .dequeueReusableCell(withReuseIdentifier: CategoryFilterCVC.className,
                                         for: indexPath) as? CategoryFilterCVC else {
                    fatalError("Cannot deqeue cells named CategoryFilterCVC")
                }
                
                return cell
                
            default:
                guard let cell = collectionView
                    .dequeueReusableCell(withReuseIdentifier: CategoryChipCVC.className,
                                         for: indexPath) as? CategoryChipCVC else {
                    fatalError("Cannot deqeue cells named CategoryChipCVC")
                }
                cell.configureCategoryChipCVC(category: categoryType)
                
                return cell
            }
        }
        
        viewmodel.output.placeCategoryDataSources
            .bind(to: placeCategoryCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
}

// MARK: - NaverMap Delegate

extension HomeVC: NMFMapViewTouchDelegate {
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print(latlng)
    }
    
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        print("tapedd")
        
        return true
    }
    
}
