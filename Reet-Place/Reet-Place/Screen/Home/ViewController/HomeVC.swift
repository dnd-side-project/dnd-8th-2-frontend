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
            $0.backgroundColor = .yellow
            
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
            
            $0.register(CategoryFilterCVC.self, forCellWithReuseIdentifier: CategoryFilterCVC.className)
            $0.register(CategoryChipCVC.self, forCellWithReuseIdentifier: CategoryChipCVC.className)
        }
    
    private let currentPositionButton = ReetFAB(size: .round(.small), title: nil, image: .directionTool)
    
    // MARK: - Variables and Properties
    
    private let viewmodel = HomeVM()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
////        placeCategoryCollectionView.invalidateIntrinsicContentSize()
//    }
    
    override func configureView() {
        super.configureView()
        
        configureMapView()
        configureCollectionView()
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
        
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: 37.35838205147338, lng: 127.1052659318825)
        marker.mapView = mapView
        
        
        let image = NMFOverlayImage(name: "Marker")
        marker.iconImage = image
    }
    
    private func configureCollectionView() {
        _ = placeCategoryCollectionView
            .then {
                $0.backgroundColor = .clear
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
            $0.left.equalTo(mapView.snp.left).offset(20.0)
            $0.right.equalTo(mapView.snp.right).offset(-20.0)
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
                print(owner)
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
            .bind(onNext: {
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
            .drive(onNext: {
                print("TODO: - located mapView current position")
            })
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

extension HomeVC: NMFMapViewTouchDelegate {
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print(latlng)
    }
    
}
