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
        
        var tabPlaceCategoryList: BehaviorRelay<Array<TabPlaceCategoryList>> = BehaviorRelay(value: TabPlaceCategoryList.allCases)
        var tabPlaceCategoryDataSources: Observable<Array<TabPlaceCategoryListDataSource>> {
            tabPlaceCategoryList.map { [TabPlaceCategoryListDataSource(items: $0)] }
        }
        
        var categoryDetailFoodList: BehaviorRelay<Array<CategoryDetailFoodList>> = BehaviorRelay(value: CategoryDetailFoodList.allCases)
        var categoryDetailFoodDataSource: Observable<Array<CategoryDetailFoodDataSource>> {
            categoryDetailFoodList.map { [CategoryDetailFoodDataSource(items: $0)] }
        }
        
        var categoryDetailActivityList: BehaviorRelay<Array<CategoryDetailActivityList>> = BehaviorRelay(value: CategoryDetailActivityList.allCases)
        var categoryDetailActivityDataSource: Observable<Array<CategoryDetailActivityDataSource>> {
            categoryDetailActivityList.map { [CategoryDetailActivityDataSource(items: $0)] }
        }
        
        var categoryDetailPhotoBoothList: BehaviorRelay<Array<CategoryDetailPhotoBoothList>> = BehaviorRelay(value: CategoryDetailPhotoBoothList.allCases)
        var categoryDetailPhotoBoothDataSource: Observable<Array<CategoryDetailPhotoBoothDataSource>> {
            categoryDetailPhotoBoothList.map { [CategoryDetailPhotoBoothDataSource(items: $0)] }
        }
        
        var categoryDetailShoppingList: BehaviorRelay<Array<CategoryDetailShoppingList>> = BehaviorRelay(value: CategoryDetailShoppingList.allCases)
        var categoryDetailShoppingDataSource: Observable<Array<CategoryDetailShoppingDataSource>> {
            categoryDetailShoppingList.map { [CategoryDetailShoppingDataSource(items: $0)] }
        }
        
        var categoryDetailCafeList: BehaviorRelay<Array<CategoryDetailCafeList>> = BehaviorRelay(value: CategoryDetailCafeList.allCases)
        var categoryDetailCafeDataSource: Observable<Array<CategoryDetailCafeDataSource>> {
            categoryDetailCafeList.map { [CategoryDetailCafeDataSource(items: $0)] }
        }
        
        var categoryDetailCultureList: BehaviorRelay<Array<CategoryDetailCultureList>> = BehaviorRelay(value: CategoryDetailCultureList.allCases)
        var categoryDetailCultureDataSource: Observable<Array<CategoryDetailCultureDataSource>> {
            categoryDetailCultureList.map { [CategoryDetailCultureDataSource(items: $0)] }
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
}

// MARK: - Input

extension CategoryFilterBottomSheetVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension CategoryFilterBottomSheetVM: Output {
    func bindOutput() {}
}
