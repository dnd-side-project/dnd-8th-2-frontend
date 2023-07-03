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
        var searchResultList: BehaviorRelay<Array<BookmarkCardModel>> = BehaviorRelay(value: [
                                                                                        BookmarkCardModel(placeName: "꾸꾸루꾸바베큐 서울역점", categoryName: "식도락", starCount: 0, address: "서울 용산구 청파로 391", groupType: "", infoCount: 0, withPeople: "신영 나은 훈성 재욱 희재 태현 철우", relLink1: "https://pf.kakao.com/_SxfBCT", relLink2: "https://blog.naver.com/fofori123/222995635405", relLink3: nil),
                                                                                        BookmarkCardModel(placeName: "카페 레이어드 연남점", categoryName: "카페", starCount: 0, address: "서울 마포구 성미산로 161-4", groupType: "", infoCount: 0, withPeople: "훈성 재욱", relLink1: "https://www.instagram.com/cafe_layered/", relLink2: nil, relLink3: nil),
                                                                                        BookmarkCardModel(placeName: "연남토마", categoryName: "식도락", starCount: 0, address: "서울 마포구 월드컵북로6길 61 연남토마", groupType: "", infoCount: 0, withPeople: "태현", relLink1: "https://instagram.com/toma_wv?igshid=1w7phujmmcjm6", relLink2: nil, relLink3: nil),
                                                                                        BookmarkCardModel(placeName: "쭉심", categoryName: "식도락", starCount: 3, address: "서울 관악구 봉천로 597 최일빌딩", groupType: "다녀왔어요", infoCount: 2, withPeople: "태현", relLink1: "https://blog.naver.com/jet1125love/223009010644", relLink2: nil, relLink3: nil),
                                                                                        BookmarkCardModel(placeName: "작당모의", categoryName: "카페", starCount: 2, address: "서울 마포구 동교로32길 19 1층", groupType: "가고싶어요", infoCount: 0, withPeople: "태현 희재 철우", relLink1: "https://www.instagram.com/zakdangmoi/", relLink2: nil, relLink3: nil),
                                                                                        BookmarkCardModel(placeName: "명동교자 본점", categoryName: "식도락", starCount: 1, address: "서울 중구 명동10길 29", groupType: "가고싶어요", infoCount: 1, withPeople: "", relLink1: "http://www.mdkj.co.kr/", relLink2: nil, relLink3: nil),
                                                                                        BookmarkCardModel(placeName: "스탠스커피", categoryName: "카페", starCount: 0, address: "서울 마포구 와우산로11길 9 1층", groupType: "", infoCount: 0, withPeople: "훈성 재욱", relLink1: "http://instagram.com/stancecoffee", relLink2: nil, relLink3: nil),
                                                                                        BookmarkCardModel(placeName: "몽탄", categoryName: "식도락", starCount: 1, address: "서울 용산구 백범로99길 50", groupType: "", infoCount: 2, withPeople: "", relLink1: "http://www.mongtan.co.kr", relLink2: "https://blog.naver.com/suuming_/223003849162", relLink3: nil),
                                                                                        BookmarkCardModel(placeName: "스테이크 슈퍼", categoryName: "식도락", starCount: 0, address: "서울 마포구 독막로7길 62 1층 스테이크 슈퍼", groupType: "", infoCount: 0, withPeople: "희재 훈성", relLink1: "http://instagram.com/steaksuper_official", relLink2: nil, relLink3: nil),
                                                                                        BookmarkCardModel(placeName: "합정티라미수", categoryName: "카페", starCount: 2, address: "서울 마포구 양화로3길 55 지하1층 합정티라미수", groupType: "다녀왔어요", infoCount: 1, withPeople: "나은", relLink1: nil, relLink2: nil, relLink3: nil),
                                                                                        BookmarkCardModel(placeName: "어글리베이커리", categoryName: "카페", starCount: 0, address: "서울 마포구 월드컵로13길 73 1층 어글리 베이커리", groupType: "", infoCount: 0, withPeople: "태현", relLink1: "http://www.instagram.com/uglybakery", relLink2: nil, relLink3: nil),
                                                                                        BookmarkCardModel(placeName: "감성타코 합정점", categoryName: "식도락", starCount: 0, address: "서울 마포구 월드컵로3길 14 지하1층", groupType: "", infoCount: 0, withPeople: "", relLink1: "http://instagram.com/gamsungtaco", relLink2: nil, relLink3: nil)
        ])
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
