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
    private let categoryDetailScrollView = UIScrollView()
        .then {
            $0.showsHorizontalScrollIndicator = false
            $0.isPagingEnabled = true
            $0.isUserInteractionEnabled = false
        }
    private let categoryDetailStackView = UIStackView()
        .then {
            $0.spacing = 0
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.alignment = .fill
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
        
        configurePlaceBottomSheet()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindCategoryDetailScrollView()
        bindButton()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        bindMenuTabBarView()
    }
    
    override func showBottomSheet() {
        menuTabBarView.menuBarCollectionView.snp.updateConstraints {
            $0.height.equalTo(32.0)
        }
        
        super.showBottomSheet()
    }
    
}

// MARK: - Configure

extension CategoryFilterBottomSheet {
    
    private func configurePlaceBottomSheet() {
        sheetStyle = .h420
    }
    
}

// MARK: - Layout

extension CategoryFilterBottomSheet {
    
    private func configureLayout() {
        view.addSubviews([menuTabBarView,
                          categoryDetailScrollView,
                          resetButton, saveButton])
        categoryDetailScrollView.addSubviews([categoryDetailStackView])
        
        TabPlaceCategoryList.allCases.forEach {
            let categoryDetailView = $0.creatCategoryDetailView()
            
            categoryDetailStackView.addArrangedSubview(categoryDetailView)
            categoryDetailView.snp.makeConstraints {
                $0.width.equalTo(screenWidth)
                $0.height.equalTo(categoryDetailStackView)
            }
            
            categoryDetailView.bindCategoryDetailList(viewModel: viewModel, bag: bag)
            categoryDetailView.bindCollectionView(bag: bag)
        }
        
        menuTabBarView.snp.makeConstraints {
            $0.top.equalTo(bottomSheetView.snp.top).offset(23.0)
            $0.horizontalEdges.equalTo(bottomSheetView)
        }
        
        categoryDetailScrollView.snp.makeConstraints {
            $0.top.equalTo(menuTabBarView.snp.bottom)
            $0.horizontalEdges.equalTo(bottomSheetView)
        }
        categoryDetailStackView.snp.makeConstraints {
            $0.width.equalTo(screenWidth * CGFloat(TabPlaceCategoryList.allCases.count))
            $0.height.equalTo(categoryDetailScrollView)

            $0.edges.equalTo(categoryDetailScrollView)
        }
        
        resetButton.snp.makeConstraints {
            $0.width.equalTo(89.0)
            $0.height.equalTo(48.0)
            
            $0.leading.equalTo(bottomSheetView.snp.leading).offset(20.0)
            $0.bottom.equalTo(saveButton)
        }
        saveButton.snp.makeConstraints {
            $0.height.equalTo(resetButton)
            
            $0.top.equalTo(categoryDetailScrollView.snp.bottom).offset(4.0)
            $0.leading.equalTo(resetButton.snp.trailing).offset(12.0)
            $0.trailing.equalTo(bottomSheetView.snp.trailing).offset(-20.0)
            $0.bottom.equalTo(bottomSheetView.snp.bottom).offset(-36.0)
        }
    }
    
}

// MARK: - Input

extension CategoryFilterBottomSheet {
    
    private func bindCategoryDetailScrollView() {
        menuTabBarView.menuBarCollectionView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let offset = CGFloat(indexPath.row) * self.screenWidth
                
                let menuBarCV: ReetMenuTabBarView = self.menuTabBarView
                switch indexPath.row {
                case 0:
                    menuBarCV.scrollToStartTab()
                case TabPlaceCategoryList.allCases.count - 1:
                    menuBarCV.scrollToEndTab(rightInset: 20.0)
                default:
                    break
                }
                
                self.categoryDetailScrollView.scrollToHorizontalOffset(offset: offset)
            })
            .disposed(by: bag)
    }
    
    private func bindButton() {
        resetButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                
                print("resetButton pressed")
            })
            .disposed(by: bag)
        
        saveButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                
                print("saveButton pressed")
            })
            .disposed(by: bag)
    }
    
}

// MARK: - Output

extension CategoryFilterBottomSheet {
    
    private func bindMenuTabBarView() {
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
    
}
