//
//  CategoryFilterBottomSheet.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/04/20.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources
import RxGesture

import SnapKit
import Then

class CategoryFilterBottomSheet: ReetBottomSheet {
    
    // MARK: - UI components
    
    private let menuTabBarView = ReetMenuTabBarView()
        .then {
            $0.configureMenuBarCollectionView(customSectionInset: UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0))
        }
    
    private let categoryDetailListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        .then {
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.register(CategoryDetailListCVC.self, forCellWithReuseIdentifier: CategoryDetailListCVC.className)
        }
    
    private let buttonStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.distribution = .fillProportionally
            $0.alignment = .fill
            $0.spacing = 12.0
        }
    private let resetButton = ReetTextButton(with: "ResetSelectedCategory".localized, for: .tertiary, left: AssetsImages.refresh)
    private let saveButton = ReetButton(with: "SaveSelectedCategory".localized, for: ReetButtonStyle.secondary)
    
    // MARK: - Variables and Properties
    
    private let viewModel = CategoryFilterBottomSheetVM()
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        menuTabBarView.setTabPosition(indexPath: IndexPath(item: 0, section: 0))
    }
    
    override func configureView() {
        super.configureView()
        
        configureFilterBottomSheet()
        configureCategoryDetailListCollectionView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindInputMenuTabBarView()
        bindCategoryDetailScrollView()
        bindButton()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        bindOutputMenuTabBarView()
        bindCategoryDetailListCollectionView()
    }
    
    // MARK: - Functions
    
    private func checkCategoryFilterSetting() {
        switch KeychainManager.shared.read(for: .accessToken) == nil {
        case true: // 비 로그인
            configureLocalFilterSettings()
        case false: // 로그인
            configureLocalFilterSettings()
        }
    }
    
}

// MARK: - Configure

extension CategoryFilterBottomSheet {
    
    private func configureFilterBottomSheet() {
        sheetStyle = .h420
    }
    
    private func configureLocalFilterSettings() {
        // TODO: - 비로그인 사용자가 설정한 카테고리 조회 기능 구현(CoreData)
        if let data = CoreDataManager.shared.get(targetEntity: .categoryDetail) {
            for i in 0..<data.count {
                print(data[i].value(forKey: .empty))
            }
        }
    }
    
    private func configureCategoryDetailListCollectionView() {
        let categoryDetailListCollectionViewHeight = 277.0
        
        let layout = UICollectionViewFlowLayout()
            .then {
                $0.scrollDirection = .horizontal
                $0.minimumLineSpacing = 0.0
                $0.minimumInteritemSpacing = 0.0
                $0.itemSize = CGSize(width: screenWidth, height: categoryDetailListCollectionViewHeight)
            }
        categoryDetailListCollectionView.collectionViewLayout = layout
    }
    
}

// MARK: - Layout

extension CategoryFilterBottomSheet {
    
    private func configureLayout() {
        // Add Subviews
        view.addSubviews([menuTabBarView,
                          categoryDetailListCollectionView,
                          buttonStackView])
        
        [resetButton, saveButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        // Make Constraints
        menuTabBarView.snp.makeConstraints {
            $0.top.equalTo(bottomSheetView.snp.top).offset(23.0)
            $0.horizontalEdges.equalTo(bottomSheetView)
        }
        
        categoryDetailListCollectionView.snp.makeConstraints {
            $0.top.equalTo(menuTabBarView.snp.bottom)
            $0.horizontalEdges.equalTo(bottomSheetView)
            $0.bottom.equalTo(buttonStackView.snp.top).offset(-4.0)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.height.equalTo(48.0)
            $0.top.equalTo(bottomSheetView.snp.top).offset(336.0)
            $0.horizontalEdges.equalTo(bottomSheetView).inset(20.0)
        }
        resetButton.snp.makeConstraints {
            $0.width.equalTo(89.0)
        }
    }
    
}

// MARK: - Input

extension CategoryFilterBottomSheet {
    
    private func bindInputMenuTabBarView() {
        menuTabBarView.menuBarCollectionView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                
                self.menuTabBarView.menuBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                
                let offset = CGFloat(indexPath.row) * self.screenWidth
                self.categoryDetailListCollectionView.scrollToHorizontalOffset(offset: offset)
            })
            .disposed(by: bag)
    }
    
    private func bindCategoryDetailScrollView() {
        categoryDetailListCollectionView.rx.willEndDragging
            .asDriver()
            .drive(onNext: { [weak self] velocity, targetContentOffset in
                guard let self = self else { return }
                
                let menuIndex = Int(targetContentOffset.pointee.x / self.categoryDetailListCollectionView.frame.width)
                let indexPath = IndexPath(item: menuIndex, section: 0)
                self.menuTabBarView.menuBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            })
            .disposed(by: bag)
    }
    
    private func bindButton() {
        resetButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                
                // TODO: - 리셋버튼 클릭시 선택된 카테고리 원상태로 복구 기능 리팩토링
            })
            .disposed(by: bag)
        
        saveButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                
                // TODO: - 저장버튼 클릭시 선택된 카테고리 조회 기능 리팩토링
                
                self.dismissBottomSheet()
            })
            .disposed(by: bag)
    }
    
}

// MARK: - Output

extension CategoryFilterBottomSheet {
    
    private func bindOutputMenuTabBarView() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<TabPlaceCategoryListDataSource> { _,
            collectionView,
            indexPath,
            tabCategoryType in
            
            guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: ReetMenuTarBarCVC.className,
                                     for: indexPath) as? ReetMenuTarBarCVC else {
                fatalError("Cannot deqeue cells named ReetMenuTarBarCVC")
            }
            cell.configureReetMenuTarBarCVC(tabPlaceCategory: tabCategoryType)
            
            return cell
        }
        
        viewModel.output.tabPlaceCategoryDataSources
            .bind(to: menuTabBarView.menuBarCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    private func bindCategoryDetailListCollectionView() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<CategoryDetailListDataSource> { _,
            collectionView,
            indexPath,
            categoryType in
            
            guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: CategoryDetailListCVC.className,
                                     for: indexPath) as? CategoryDetailListCVC else {
                fatalError("Cannot deqeue cells named CategoryDetailListCVC")
            }
            cell.configureCategoryDetailListCVC(categoryType: categoryType, viewModel: self.viewModel)
            
            return cell
        }
        
        viewModel.output.categoryDetailListDataSource
            .bind(to: categoryDetailListCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
}
