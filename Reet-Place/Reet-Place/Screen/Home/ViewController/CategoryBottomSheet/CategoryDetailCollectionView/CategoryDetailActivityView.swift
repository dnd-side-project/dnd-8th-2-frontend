//
//  CategoryDetailActivityView.swift
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

class CategoryDetailActivityView: CategoryDetailView {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    // MARK: - Functions
    
    override func bindCategoryDetailList(viewModel: CategoryFilterBottomSheetVM, bag: DisposeBag) {
        let dataSource = RxCollectionViewSectionedReloadDataSource<CategoryDetailActivityDataSource> { _,
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

        viewModel.output.categoryDetailActivityDataSource
            .bind(to: categoryDetailCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
}

// MARK: - Output

//extension CategoryDetailActivityView: CategoryDetailViewDelegate {
extension CategoryDetailActivityView {
    
//    func bindCategoryDetailList(viewModel: CategoryFilterBottomSheetVM, bag: DisposeBag) {
    
    
}
