//
//  CategoryFilterBottomSheetVM.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/05/03.
//

import RxCocoa
import RxSwift

final class CategoryFilterBottomSheetVM {
    
    // MARK: - Variables and Properties
    
    var input = Input()
    var output = Output()
    
    let network: NetworkProtocol = NetworkProvider()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    struct Input {}
    struct Output {
        var loading = BehaviorRelay<Bool>(value: false)
        var isLoginUser = KeychainManager.shared.read(for: .accessToken) != nil
        var isModifySuccess = PublishRelay<Bool>()
        
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

// MARK: - Networking

extension CategoryFilterBottomSheetVM {
    
    func requestCategoryFilterList(category: TabPlaceCategoryList, dispatchGroup: DispatchGroup) {
        let parameterCategory = category.parameterCategory
        let path = "/api/places/category?category=\(parameterCategory)"
        let endPoint = EndPoint<CategoryFilterResponseModel>(path: path, httpMethod: .get)
        
        network.request(with: endPoint)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let data):
                    CoreDataManager.shared.addCategoryFilter(placeCategory: PlaceCategoryModel(category: parameterCategory, subCategory: data.contents))
                    dispatchGroup.leave()
                case .failure(let error):
                    owner.apiError.onNext(error)
                }
            })
            .disposed(by: bag)
    }
    
    func requestModifyCategoryFilterList() {
        let placeCategoryList = ModificationCategoryFilterRequestModel(contents: output.placeCategorySelectionList)
        let path = "/api/places/category"
        let endPoint = EndPoint<EmptyEntity>(path: path,
                                             httpMethod: .put,
                                             body: placeCategoryList)
        
        network.request(with: endPoint)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(_):
                    owner.output.isModifySuccess.accept(true)
                case .failure(let error):
                    owner.output.isModifySuccess.accept(false)
                    owner.apiError.onNext(error)
                }
            })
            .disposed(by: bag)
    }
    
}
