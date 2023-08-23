//
//  CategoryDetailFoodView.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/05/07.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

import Then
import SnapKit

class CategoryDetailFoodView: CategoryDetailView {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func configureCollectionView() {
        configureCollectionViewLayout(headerWidth: frame.size.width, headerHeight: 21.0,
                                      sectionInsetTop: 8.0, sectionInsetBottom: 24.0)
        categoryDetailCollectionView.register(CategoryDetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryDetailHeaderView.className)
    }
    
    // MARK: - Functions
    
    override func bindCategoryDetailList(viewModel: CategoryFilterBottomSheetVM, bag: DisposeBag) {
        let dataSource = RxCollectionViewSectionedReloadDataSource<CategoryDetailFoodDataSource>( configureCell: {
            _,
            collectionView,
            indexPath,
            categoryType in
            
            guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: DetailCategoryChipCVC.className,
                                     for: indexPath) as? DetailCategoryChipCVC else {
                fatalError("Cannot deqeue cells named DetailCategoryChipCVC")
            }
            cell.configureDetailPlaceCategoryChipCVC(detailCategoryTitle: categoryType.description)

            return cell
        }, configureSupplementaryView: {
            dataSource,
            collectionView,
            title,
            indexPath in
            
            guard let header = collectionView
                .dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                  withReuseIdentifier: CategoryDetailHeaderView.className,
                                                  for: indexPath) as? CategoryDetailHeaderView else {
                fatalError("Cannot deqeue SupplementaryView named CategoryDetailHeaderView")
            }
            header.configureHeaderView(title: dataSource[indexPath.section].header)
            
            return header
          })

        viewModel.output.categoryDetailFoodDataSource
            .bind(to: categoryDetailCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
}
