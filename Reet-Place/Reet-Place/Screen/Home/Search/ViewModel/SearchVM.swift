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
        var loading = BehaviorRelay<Bool>(value: false)
        
        var categoryHistoryList: BehaviorRelay<Array<TabPlaceCategoryList>> = BehaviorRelay(value: TabPlaceCategoryList.allCases)
        var tabPlaceCategoryDataSources: Observable<Array<TabPlaceCategoryListDataSource>> {
            categoryHistoryList.map { [TabPlaceCategoryListDataSource(items: $0)] }
        }
        
        var searchHistoryList: BehaviorRelay<Array<TabPlaceCategoryList>> = BehaviorRelay(value: TabPlaceCategoryList.allCases)
        var searchHistoryListDataSource: Observable<Array<SearchHistoryListDataSource>> {
            searchHistoryList.map { [SearchHistoryListDataSource(items: $0)] }
        }
        
        // TODO: - 검색결과 더미데이터 삭제
        var searchResultList: BehaviorRelay<Array<BookmarkCardModel>> = BehaviorRelay(value: [])
        var searchResultDataSource: Observable<Array<SearchResultDataSource>> {
            searchResultList.map { [SearchResultDataSource(items: $0)] }
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

extension SearchVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension SearchVM: Output {
    func bindOutput() {}
}
