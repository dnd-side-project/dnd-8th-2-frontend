//
//  HomeVM.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/26.
//

import RxCocoa
import RxSwift

import Alamofire

final class HomeVM {
    
    // MARK: - Variables and Properties
    
    var input = Input()
    var output = Output()
    
    let network: NetworkProtocol = NetworkProvider()
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
        var placeResultListDataSource: Observable<Array<PlaceResultListDataSource>> {
            searchPlaceList.map { [PlaceResultListDataSource(items: $0.contents)] }
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

extension HomeVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension HomeVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension HomeVM {
    
    /// 주어진 좌표를 중심으로 해당 카테고리와 관련된 장소목록 조회
    func requestSearchPlaces(category: PlaceCategoryList, latitude: String, longitude: String) {
        let path = "/api/places"
        var searchPlaceListRequestModel = SearchPlaceListRequestModel(lat: latitude, 
                                                                      lng: longitude,
                                                                      category: category.parameterPlace,
                                                                      subCategory: [])
        
        // 비로그인 사용자의 경우
        if KeychainManager.shared.read(for: .accessToken) == nil,
           category != .reetPlaceHot {
            searchPlaceListRequestModel.subCategory = CoreDataManager.shared.fetchSubCategoryList(targetTabPlace: TabPlaceCategoryList(rawValue: category.parameterPlace))
        }
        
        let endPoint = EndPoint<SearchPlaceListResponseModel>(path: path,
                                                              httpMethod: .post,
                                                              body: searchPlaceListRequestModel)
        
        network.request(with: endPoint)
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
