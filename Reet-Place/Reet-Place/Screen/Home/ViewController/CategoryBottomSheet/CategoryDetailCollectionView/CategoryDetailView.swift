//
//  CategoryDetailView.swift
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

class CategoryDetailView: BaseView {
    
    // MARK: - UI components
    
    let categoryDetailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        .then {
            $0.backgroundColor = .clear

            let layout = LeftAlignmentCollectionViewFlowLayout()
                .then {
                    $0.scrollDirection = .vertical
                    $0.minimumLineSpacing = 12.0
                    $0.minimumInteritemSpacing = 8.0
                    $0.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
                    $0.estimatedItemSize = CGSize(width: 72.0, height: 32.0)
                    $0.itemSize = UICollectionViewFlowLayout.automaticSize
                }
            $0.collectionViewLayout = layout
            
            $0.showsHorizontalScrollIndicator = false
            $0.clipsToBounds = false
            
            $0.register(CategoryChipCVC.self, forCellWithReuseIdentifier: CategoryChipCVC.className)
        }
    
    // MARK: - Variables and Properties
    
    var tabCategory: TabPlaceCategoryList
    
    // MARK: - Life Cycle
    
    init(frame: CGRect = .zero,
         tabCategory: TabPlaceCategoryList) {
        self.tabCategory = tabCategory
        
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        super.configureView()
        
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Functions
    
    func bindCategoryDetailList(viewModel: CategoryFilterBottomSheetVM, bag: DisposeBag) {}
}

// MARK: - Layout

extension CategoryDetailView {
    
    private func configureLayout() {
        addSubviews([categoryDetailCollectionView])
        
        categoryDetailCollectionView.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(16.0)
            $0.horizontalEdges.equalToSuperview().inset(20.0)
            $0.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - Input

extension CategoryDetailView {
    
    func bindCollectionView(bag: DisposeBag) {
        categoryDetailCollectionView.rx.modelSelected(PlaceCategoryList.self)
            .withUnretained(self)
            .bind(onNext: { owner, category in
                print("detail: ", category)
            })
            .disposed(by: bag)

        categoryDetailCollectionView.rx.itemSelected
            .withUnretained(self)
            .bind(onNext: { owner, indexPath in
                print("detail: ", indexPath)
            })
            .disposed(by: bag)
    }
    
}
