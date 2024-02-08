//
//  SearchVM.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/06/01.
//

import RxCocoa
import RxSwift

final class SearchVM: BaseViewModel {
    
    // MARK: - Variables and Properties
    
    var input = Input()
    var output = Output()
    
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    struct Input {}
    struct Output {
        var isLoginUser = KeychainManager.shared.read(for: .accessToken) != nil
        
        var categoryHistoryList: BehaviorRelay<Array<TabPlaceCategoryList>> = BehaviorRelay(value: TabPlaceCategoryList.allCases)
        var tabPlaceCategoryDataSources: Observable<Array<TabPlaceCategoryListDataSource>> {
            categoryHistoryList.map { [TabPlaceCategoryListDataSource(items: $0)] }
        }
        
        var searchHistory = SearchHistory()
        
        var searchResult = SearchResult()
    }
    
    /// 장소검색 키워드 히스토리
    struct SearchHistory {
        var keywordList: PublishRelay<Array<SearchHistoryContent>> = PublishRelay<Array<SearchHistoryContent>>()
        var isUpdated: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        
        var list: BehaviorRelay<Array<TabPlaceCategoryList>> = BehaviorRelay(value: TabPlaceCategoryList.allCases)
        var dataSource: Observable<Array<SearchHistoryListDataSource>> {
            list.map { [SearchHistoryListDataSource(items: $0)] }
        }
    }
    
    /// 장소검색 결과 목록
    struct SearchResult {
        var list = BehaviorRelay<[SearchPlaceKeywordListContent]>(value: [])
        var dataSource: Observable<Array<SearchResultDataSource>> {
            list.map { [SearchResultDataSource(items: $0)] }
        }
        var page = 1
        var lastPage: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        var isPaging: BehaviorRelay<Bool> = BehaviorRelay(value: false)
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
    
    func updateKeywordHistory() {
        output.searchHistory.keywordList.accept(CoreDataManager.shared.getKeywordHistoryList())
    }
}

// MARK: - Input

extension SearchVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension SearchVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension SearchVM {
    
    func requestSearchPlaceKeyword(placeKeyword: SearchPlaceKeywordRequestModel) {
        let path = "/api/places/search"
        let resource = URLResource<SearchPlaceKeywordResponseModel>(path: path)
        
        output.searchResult.isPaging.accept(true)
        
        apiSession.requestPost(urlResource: resource, parameter: placeKeyword.parameter)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let data):
                    switch placeKeyword.page {
                    case 1:
                        owner.output.searchResult.list.accept(data.contents)
                    default:
                        let curData = owner.output.searchResult.list.value
                        owner.output.searchResult.list.accept(curData + data.contents)
                    }
                    owner.output.searchResult.lastPage.accept(data.lastPage)
                    owner.output.searchResult.page = placeKeyword.page
                case .failure(let error):
                    owner.apiError.onNext(error)
                }
                
                owner.output.searchResult.isPaging.accept(false)
            })
            .disposed(by: bag)
    }
    
}
