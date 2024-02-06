//
//  HomeVM.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/26.
//

import RxCocoa
import RxSwift

import Alamofire

final class HomeVM: BaseViewModel {
    
    // MARK: - Variables and Properties
    
    var input = Input()
    var output = Output()
    
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    struct Input {}
    struct Output {
        var loading = BehaviorRelay<Bool>(value: false)
        
        private var placeCategoryList: BehaviorRelay<Array<PlaceCategoryList>> = BehaviorRelay(value: PlaceCategoryList.allCases)
        var placeCategoryDataSources: Observable<Array<PlaceCategoryListDataSource>> {
            placeCategoryList.map { [PlaceCategoryListDataSource(items: $0)] }
        }
        
        var searchPlaceList = PublishRelay<SearchPlaceListResponseModel>()
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

extension HomeVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension HomeVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension HomeVM {
    
    func requestSearchPlaces(category: PlaceCategoryList, latitude: String, longitude: String) {
        let path = "/api/places"
        let resource = URLResource<SearchPlaceListResponseModel>(path: path)
        
        var searchPlaceListRequestModel = SearchPlaceListRequestModel(lat: latitude, 
                                                                      lng: longitude,
                                                                      category: category.parameterPlace,
                                                                      subCategory: [])
        
        // 비로그인 사용자의 경우
        if KeychainManager.shared.read(for: .accessToken) == nil,
           category != .reetPlaceHot {
            searchPlaceListRequestModel.subCategory = CoreDataManager.shared.fetchSubCategoryList(targetTabPlace: TabPlaceCategoryList(rawValue: category.parameterPlace)!)
        }
        
        apiSession.requestPost(urlResource: resource, parameter: searchPlaceListRequestModel.parameter)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let data):
                    owner.output.searchPlaceList.accept(data)
                case .failure(let error):
                    owner.apiError.onNext(error)
                }
            })
            .disposed(by: bag)
    }
    
}
