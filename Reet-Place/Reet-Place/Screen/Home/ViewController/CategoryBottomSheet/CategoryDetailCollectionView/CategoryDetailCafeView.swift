//
//  CategoryDetailCafeView.swift
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

class CategoryDetailCafeView: CategoryDetailView {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    // MARK: - Functions
    
    override func bindCategoryDetailList(viewModel: CategoryFilterBottomSheetVM, bag: DisposeBag) {
        let dataSource = RxCollectionViewSectionedReloadDataSource<CategoryDetailCafeDataSource> { _,
            collectionView,
            indexPath,
            categoryType in

            guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: CategoryChipCVC.className,
                                     for: indexPath) as? CategoryChipCVC else {
                fatalError("Cannot deqeue cells named CategoryChipCVC")
            }
            cell.configureDetailPlaceCategoryChipCVC(category: categoryType.description)

            return cell
        }

        viewModel.output.categoryDetailCafeDataSource
            .bind(to: categoryDetailCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
}

