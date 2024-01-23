//
//  CategoryDetailListCVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/10/16.
//

import UIKit

import Then
import SnapKit

import RxCocoa
import RxSwift
import RxDataSources

class CategoryDetailListCVC : BaseCollectionViewCell {
    
    // MARK: - UI components
    
    private let categoryDetailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        .then {
            $0.backgroundColor = .clear
            
            $0.allowsMultipleSelection = true
            $0.showsHorizontalScrollIndicator = false
            $0.clipsToBounds = false
            
            $0.register(CategoryDetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryDetailHeaderView.className)
            $0.register(DetailCategoryChipCVC.self, forCellWithReuseIdentifier: DetailCategoryChipCVC.className)
        }
    
    // MARK: - Variables and Properties
    
    var bag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bag = DisposeBag()
    }
    
    override func configureView() {
        super.configureView()
        
        configureCollectionViewLayout()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Functions
    
}

// MARK: - Configure

extension CategoryDetailListCVC {
    
    /// 세부 카테고리 목록 콜렉션 뷰와 관련된 설정을 하는 함수
    func configureCategoryDetailListCVC(categoryType: TabPlaceCategoryList, viewModel: CategoryFilterBottomSheetVM) {
        bindCategoryDetailCollectionView(categoryType: categoryType, viewModel: viewModel)
        
        switch categoryType {
        case .food:
            configureCollectionViewLayout(headerWidth: frame.size.width, headerHeight: 21.0,
                                          sectionInsetTop: 8.0, sectionInsetBottom: 24.0)
        default:
            configureCollectionViewLayout()
        }
    }
    
    private func configureCollectionViewLayout(headerWidth: CGFloat = 0.0, headerHeight: CGFloat = 0.0,
                                               sectionInsetTop: CGFloat = 0.0, sectionInsetBottom: CGFloat = 0.0) {
        let layout = LeftAlignmentCollectionViewFlowLayout()
            .then {
                $0.scrollDirection = .vertical
                $0.headerReferenceSize = CGSize(width: headerWidth, height: headerHeight)
                $0.sectionInset = UIEdgeInsets(top: sectionInsetTop, left: 0.0, bottom: sectionInsetBottom, right: 0.0)
                $0.minimumLineSpacing = 12.0
                $0.minimumInteritemSpacing = 8.0
                $0.estimatedItemSize = CGSize(width: 72.0, height: 32.0)
                $0.itemSize = UICollectionViewFlowLayout.automaticSize
            }
        categoryDetailCollectionView.collectionViewLayout = layout
    }
    
}

// MARK: - Layout

extension CategoryDetailListCVC {
    
    private func configureLayout() {
        addSubviews([categoryDetailCollectionView])
        
        categoryDetailCollectionView.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(16.0)
            $0.horizontalEdges.equalToSuperview().inset(20.0)
            $0.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - Output

extension CategoryDetailListCVC {
    
    private func bindCategoryDetailCollectionView(categoryType: TabPlaceCategoryList, viewModel: CategoryFilterBottomSheetVM) {
        let dataSource = RxCollectionViewSectionedReloadDataSource<CategoryDetailDataSource>( configureCell: {
            dataSource,
            collectionView,
            indexPath,
            categoryDetail in
            
            guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: DetailCategoryChipCVC.className,
                                     for: indexPath) as? DetailCategoryChipCVC else {
                fatalError("Cannot deqeue cells named DetailCategoryChipCVC")
            }
            cell.configureDetailPlaceCategoryChipCVC(detailCategoryTitle: categoryDetail,
                                                     detailCategoryParameter: dataSource[indexPath.section].parameterCategory[indexPath.item])
            
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
        
        viewModel.getCategoryDetailDataSource(targetCategory: categoryType)
            .bind(to: categoryDetailCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
}
