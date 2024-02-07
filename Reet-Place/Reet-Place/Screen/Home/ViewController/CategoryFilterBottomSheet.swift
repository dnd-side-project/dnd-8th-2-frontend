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
    private var isLoginUser: Bool = false
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        menuTabBarView.setTabPosition(indexPath: IndexPath(item: 0, section: 0))
    }
    
    override func configureView() {
        super.configureView()
        
        configureLoginUserPlaceCategorySelectionList()
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
        bindInputCategoryDetailListCollectionView()
        bindButton()
        bindDimmedView()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        bindOutputMenuTabBarView()
        bindOutputCategoryDetailListCollectionView()
        bindCategoryFilterModifyStatus()
    }
    
    // MARK: - Functions
}

// MARK: - Configure

extension CategoryFilterBottomSheet {
    
    private func configureLoginUserPlaceCategorySelectionList() {
        // 로그인한 사용자의 경우
        if KeychainManager.shared.read(for: .accessToken) != nil {
            isLoginUser = true
            CoreDataManager.shared.deleteCategoryFilterSelection()
            
            let dispatchGroup = DispatchGroup()
            viewModel.output.tabPlaceCategoryList.value.forEach {
                dispatchGroup.enter()
                viewModel.requestCategoryFilterList(category: $0, dispatchGroup: dispatchGroup)
            }
            
            dispatchGroup.notify(queue: .main) {
                self.categoryDetailListCollectionView.reloadData()
            }
        }
    }
    
    private func configureFilterBottomSheet() {
        sheetStyle = .h420
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
    
    private func bindInputCategoryDetailListCollectionView() {
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
                
                CoreDataManager.shared.resetSubCategorySelection()
                categoryDetailListCollectionView.reloadData()
            })
            .disposed(by: bag)
        
        saveButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                
                if isLoginUser {
                    viewModel.requestModifyCategoryFilterList()
                } else {
                    CoreDataManager.shared.saveManagedObjectContext()
                    self.dismissBottomSheet()
                }
            })
            .disposed(by: bag)
    }
    
    private func bindDimmedView() {
        dimmedView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                CoreDataManager.shared.rollbackManagedObjectContext()
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
    
    private func bindOutputCategoryDetailListCollectionView() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<CategoryDetailListDataSource> { _,
            collectionView,
            indexPath,
            categoryType in
            
            guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: CategoryDetailListCVC.className,
                                     for: indexPath) as? CategoryDetailListCVC else {
                fatalError("Cannot deqeue cells named CategoryDetailListCVC")
            }
            
            let viewModel = self.viewModel
            
            let placeCategorySelectionInfo = viewModel.output.placeCategorySelectionList.first(where: { $0.category == categoryType.parameterCategory })
                ?? PlaceCategoryModel(category: categoryType.parameterCategory,
                                      subCategory: categoryType.categoryDetailParameterList)
            
            cell.configureCategoryDetailListCVC(categoryType: categoryType,
                                                detailCategoryDataSource: viewModel.getCategoryDetailDataSource(targetCategory: categoryType),
                                                detailCategorySelectionInfo: placeCategorySelectionInfo)
            
            return cell
        }
        
        viewModel.output.categoryDetailListDataSource
            .bind(to: categoryDetailListCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    private func bindCategoryFilterModifyStatus() {
        viewModel.output.isModifySuccess
            .withUnretained(self)
            .bind(onNext: { owner, isModifySuccess in
                switch isModifySuccess {
                case true:
                    owner.dismissBottomSheet()
                case false:
                    owner.showErrorAlert("SaveSelectedCategoryFailed".localized)
                }
            })
            .disposed(by: bag)
    }
}
