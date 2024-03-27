//
//  BookmarkVM.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/04/12.
//

import RxCocoa
import RxSwift
import ReactorKit

final class BookmarkVM: Reactor {
    
    // MARK: - Properties
    
    enum Action {
        case entering
    }
    
    enum Mutation {
        case loadBookmarkTypeInfo(wishInfo: BookmarkTypeInfo, historyInfo: BookmarkTypeInfo)
        case loadBookmarkWishInfo(wishInfo: BookmarkTypeInfo)
        case loadBookmarkHistoryInfo(historyInfo: BookmarkTypeInfo)
        case verifyAuthentication(Bool)
        case error
    }
    
    struct State {
        var isAuthenticated: Bool = false
        var bookmarkTotalCount: Int = 0
        var bookmarkWishInfo: BookmarkTypeInfo = .empty
        var bookmarkHistoryInfo: BookmarkTypeInfo = .empty
    }
    
    let initialState: State
    let network: NetworkProtocol
    
    
    // MARK: - Initializer
    
    init() {
        self.initialState = State()
        self.network = NetworkProvider()
    }
    
    
    // MARK: - Mutate, Reduce
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .entering:
            return Observable.merge([
                getBookmarkList(type: .want),
                getBookmarkList(type: .done),
                checkAuthentication()
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .loadBookmarkTypeInfo(let wishInfo, let historyInfo):
            newState.bookmarkTotalCount = wishInfo.cnt + historyInfo.cnt
            newState.bookmarkWishInfo = wishInfo
            newState.bookmarkHistoryInfo = historyInfo
            
        case .loadBookmarkWishInfo(let wishInfo):
            newState.bookmarkTotalCount = state.bookmarkTotalCount + wishInfo.cnt
            newState.bookmarkWishInfo = wishInfo
            
        case .loadBookmarkHistoryInfo(let historyInfo):
            newState.bookmarkTotalCount = state.bookmarkTotalCount + historyInfo.cnt
            newState.bookmarkHistoryInfo = historyInfo
            
        case .verifyAuthentication(let isAuthenticated):
            newState.isAuthenticated = isAuthenticated
            
        case .error:
            break
        }

        return newState
    }
    
}

// MARK: - Methods

private extension BookmarkVM {
    
    /// 로그인 여부 확인
    func checkAuthentication() -> Observable<Mutation> {
        let accessToken = KeychainManager.shared.read(for: .accessToken)
        let isAuthenticated = accessToken != nil
        return Observable.just(.verifyAuthentication(isAuthenticated))
    }
}


// MARK: - Networking

private extension BookmarkVM {
    
    // TODO: - 북마크 종류 별 정보 조회 API 수정 시 교체 연결
    /// 서버에 북마크 개수 요청
    func getBookmarkCount() -> Observable<Mutation> {
        let path = "/api/bookmarks/counts"
        let endPoint = EndPoint<BookmarkCountResponseModel>(path: path, httpMethod: .get)
        
        return network.request(with: endPoint)
            .map { result -> Mutation in
                switch result {
                case .success(let data):
                    let wishInfo = BookmarkTypeInfo(type: "WANT", cnt: data.numOfWant, thumbnailUrlString: "https://picsum.photos/600/400")
                    let historyInfo = BookmarkTypeInfo(type: "GONE", cnt: data.numOfDone, thumbnailUrlString: "https://picsum.photos/600/400")
                    return .loadBookmarkTypeInfo(wishInfo: wishInfo, historyInfo: historyInfo)
                case .failure:
                    return .error
                }
            }
    }
    
    // TODO: - 북마크 종류 별 정보 조회 API 수정 시 제거
    /// 가고싶어요, 다녀왔어요 북마크를 1 페이지 씩 조회해 존재 여부 확인
    func getBookmarkList(type: BookmarkSearchType) -> Observable<Mutation> {
        let page = 0
        let path = "/api/bookmarks?searchType=\(type.rawValue)&page=\(page)&size=10&sort=LATEST"
        let endPoint = EndPoint<BookmarkListResponseModel>(path: path, httpMethod: .get)
        
        return network.request(with: endPoint)
            .map { result -> Mutation in
                switch result {
                case .success(let data):
                    let isExist: Bool = !data.content.isEmpty
                    
                    if type == .want {
                        let wishInfo: BookmarkTypeInfo = .init(type: "WANT",
                                                       cnt: isExist ? 100 : 0,
                                                       thumbnailUrlString: "https://picsum.photos/600/400")
                        return .loadBookmarkWishInfo(wishInfo: wishInfo)
                    } else if type == .done {
                        let historyInfo: BookmarkTypeInfo = .init(type: "GONE",
                                                       cnt: isExist ? 100 : 0,
                                                       thumbnailUrlString: "https://picsum.photos/600/400")
                        return .loadBookmarkHistoryInfo(historyInfo: historyInfo)
                    } else {
                        return .error
                    }
                case .failure:
                    return .error
                }
            }
    }
}
