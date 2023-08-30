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
    
    func requestSearchPlaces(targetSearchPlace: SearchPlaceListRequestModel) {
        let path = "/api/places"
        let resource = URLResource<SearchPlaceListResponseModel>(path: path)
        
        apiSession.requestPost(urlResource: resource, parameter: targetSearchPlace.parameter)
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
