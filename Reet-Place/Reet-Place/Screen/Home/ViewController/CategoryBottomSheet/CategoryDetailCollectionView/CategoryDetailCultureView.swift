//
//  CategoryDetailCultureView.swift
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

class CategoryDetailCultureView: CategoryDetailView {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    // MARK: - Functions
    
    override func bindCategoryDetailList(viewModel: CategoryFilterBottomSheetVM, bag: DisposeBag) {
        let dataSource = RxCollectionViewSectionedReloadDataSource<CategoryDetailCultureDataSource> { _,
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
        }

        viewModel.output.categoryDetailCultureDataSource
            .bind(to: categoryDetailCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
}

