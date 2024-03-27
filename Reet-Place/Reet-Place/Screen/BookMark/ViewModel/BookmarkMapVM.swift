//
//  BookmarkMapVM.swift
//  Reet-Place
//
//  Created by 김태현 on 12/13/23.
//

import RxSwift
import RxCocoa
import ReactorKit

final class BookmarkMapVM: Reactor {
    
    // MARK: - Properties
    
    enum Action {
        case entering(BookmarkSearchType)
    }
    
    enum Mutation {
        case loadBookmarkSummaries([BookmarkSummaryModel])
        case error
    }
    
    struct State {
        var bookmarkSummaries: [BookmarkSummaryModel] = []
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
        case .entering(let type):
            return getBookmarkSummaries(type: type)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .loadBookmarkSummaries(let bookmarkSummaries):
            newState.bookmarkSummaries = bookmarkSummaries
        
        case .error:
            print("Reactor Error")
        }
        
        return newState
    }
}


// MARK: - Networking

private extension BookmarkMapVM {
    
    func getBookmarkSummaries(type: BookmarkSearchType) -> Observable<Mutation> {
        let path = "/api/bookmarks/all/summaries?searchType=\(type.rawValue)"
        let endPoint = EndPoint<BookmarkSummaryListResponseModel>(path: path, httpMethod: .get)
        
        return network.request(with: endPoint)
            .map { result -> Mutation in
                switch result {
                case .success(let summariesReponse):
                    let summaries = summariesReponse.map { $0.toSummary() }
                    return .loadBookmarkSummaries(summaries)
                case .failure:
                    return .error
                }
            }
    }
    
}
