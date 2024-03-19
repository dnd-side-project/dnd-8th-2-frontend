//
//  SearchVM.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/06/01.
//

import RxCocoa
import RxSwift

final class SearchVM {
    
    // MARK: - Variables and Properties
    
    var input = Input()
    var output = Output()
    
    let network: NetworkProtocol = NetworkProvider()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    struct Input {}
    struct Output {
        var isAuthenticated: BehaviorRelay<Bool> = .init(value: KeychainManager.shared.read(for: .accessToken) != nil)
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
        var isNeedUpdated: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        var isUpdatedWithoutScroll: PublishRelay<Bool> = PublishRelay()
        
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
    
    /// 로그인 유무에 따른 사용자의 검색기록 목록 조회 요청
    func updateSearchHistory() {
        switch output.isLoginUser {
        case true:
            requestSearchHistory()
        case false:
            output.searchHistory.keywordList.accept(CoreDataManager.shared.getKeywordHistoryList())
        }
    }
    
    /// 로그인 유무에 따른 사용자의 전체 검색기록 삭제
    func deleteSearchHistory() {
        switch output.isLoginUser {
        case true:
            requestDeleteSearchHistory()
        case false:
            output.searchHistory.isNeedUpdated.accept(CoreDataManager.shared.deleteAllSearchKeyword())
        }
    }
    
    /// 로그인 유무에 따른 특정 키워드 삭제 요청
    func deleteKeyword(searchHistoryContent: SearchHistoryContent) {
        switch output.isLoginUser {
        case true:
            requestDeleteKeyword(keywordID: searchHistoryContent.id)
        case false:
            output.searchHistory.isUpdatedWithoutScroll.accept(CoreDataManager.shared.deleteSearchKeyword(targetKeyword: searchHistoryContent.query))
        }
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

// MARK: - Networking SearchHistory

extension SearchVM {
    
    /// 로그인한 사용자의 검색기록 목록 조회
    func requestSearchHistory() {
        let path = "/api/search/history"
        let endPoint = EndPoint<SearchHistoryResponseModel>(path: path, httpMethod: .get)
        
        network.request(with: endPoint)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let data):
                    owner.output.searchHistory.keywordList.accept(data.contents)
                case .failure(let error):
                    owner.apiError.onNext(error)
                }
            })
            .disposed(by: bag)
    }
    
    /// 전체 검색기록 삭제
    func requestDeleteSearchHistory() {
        let path = "/api/search/history"
        let endPoint = EndPoint<EmptyEntity>(path: path, httpMethod: .delete)
        
        network.request(with: endPoint)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(_):
                    owner.output.searchHistory.isNeedUpdated.accept(true)
                case .failure(let error):
                    owner.output.searchHistory.isNeedUpdated.accept(false)
                    owner.apiError.onNext(error)
                }
            })
            .disposed(by: bag)
    }
    
    /// 선택한 키워드 삭제
    func requestDeleteKeyword(keywordID searchId: Int) {
        let searchId = String(searchId)
        let path = "/api/search/history/\(searchId)"
        let endPoint = EndPoint<EmptyEntity>(path: path, httpMethod: .delete)
        
        network.request(with: endPoint)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(_):
                    owner.output.searchHistory.isUpdatedWithoutScroll.accept(true)
                case .failure(let error):
                    owner.output.searchHistory.isUpdatedWithoutScroll.accept(false)
                    owner.apiError.onNext(error)
                }
            })
            .disposed(by: bag)
    }
    
}

// MARK: - Networking SearchPlaceKeyword

extension SearchVM {
    
    /// 주어진 좌표를 중심으로 해당 키워드와 연관된 장소목록 조회
    func requestSearchPlaceKeyword(placeKeyword: SearchPlaceKeywordRequestModel) {
        let path = "/api/places/search"
        let endPoint = EndPoint<SearchPlaceKeywordResponseModel>(path: path,
                                                                 httpMethod: .post,
                                                                 body: placeKeyword)
        
        output.searchResult.isPaging.accept(true)
        
        network.request(with: endPoint)
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
