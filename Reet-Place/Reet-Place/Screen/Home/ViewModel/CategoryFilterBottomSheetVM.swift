//
//  CategoryFilterBottomSheetVM.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/05/03.
//

import RxCocoa
import RxSwift

final class CategoryFilterBottomSheetVM: BaseViewModel {
    
    // MARK: - Variables and Properties
    
    var input = Input()
    var output = Output()
    
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    struct Input {}
    struct Output {
        var loading = BehaviorRelay<Bool>(value: false)
        
        var tabPlaceCategoryList: BehaviorRelay<Array<TabPlaceCategoryList>> = BehaviorRelay(value: TabPlaceCategoryList.allCases.filter { $0 != .all })
        var tabPlaceCategoryDataSources: Observable<Array<TabPlaceCategoryListDataSource>> {
            tabPlaceCategoryList.map { [TabPlaceCategoryListDataSource(items: $0)] }
        }
        
        var categoryDetailListDataSource: Observable<Array<CategoryDetailListDataSource>> {
            tabPlaceCategoryList.map { [CategoryDetailListDataSource(items: $0)] }
        }
        
        var placeCategorySelectionList: [PlaceCategoryModel] {
            TabPlaceCategoryList.allCases
                .filter { $0 != .all }
                .map {
                    PlaceCategoryModel(category: $0.parameterCategory,
                                       subCategory: CoreDataManager.shared.fetchSubCategoryList(targetTabPlace: $0))
                }
        }
    }
    
    // MARK: - Life Cycle
    
    init() {
        bindInput()
        bindOutput()
    }
    
    deinit {
        bag = DisposeBag()
    }
    
    // MARK: - Functions
    
    func getCategoryDetailDataSource(targetCategory: TabPlaceCategoryList) -> Observable<Array<CategoryDetailDataSource>> {
        switch targetCategory {
        case .food:
            return BehaviorRelay(value: CategoryDetailFoodList.allCases).map {
                $0.map { CategoryDetailDataSource(header: $0.description,
                                                  items: $0.categoryDetailList,
                                                  parameterDetailCategory: $0.parameterCategory) }
            }
            
        default:
            return Observable<Array<CategoryDetailDataSource>>
                .just([CategoryDetailDataSource(header: .empty,
                                                items: targetCategory.categoryDetailList,
                                                parameterDetailCategory: targetCategory.categoryDetailParameterList)])

        }
    }
}

// MARK: - Input

extension CategoryFilterBottomSheetVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension CategoryFilterBottomSheetVM: Output {
    func bindOutput() {}
}
