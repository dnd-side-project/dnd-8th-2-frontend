//
//  BookmarkCardListVM.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/18.
//

import RxSwift
import RxCocoa
import ReactorKit

final class BookmarkCardListVM: Reactor {
    
    // MARK: - Properties
    
    enum Action {
        case entering(BookmarkSearchType)
        case deleteBookmark(index: Int)
        case removeDeletedBookmark(id: Int)
        case modifyBookmark(BookmarkInfo)
        case nextPage
        case togglingInfo(Int)
    }
    
    enum Mutation {
        case fetchBookmarkList([BookmarkCardModel], Bool)
        case modifyBookmarkList([BookmarkCardModel])
        case toggledInfo([BookmarkCardModel])
        case isLoading(Bool)
        case error
    }
    
    struct State {
        var type: BookmarkSearchType
        var page: Int = 0
        var size: Int = 20
        
        var bookmarkList: [BookmarkCardModel] = []
        var isPaging: Bool = false
        var isLastPage: Bool = false
    }
    
    let initialState: State
    let network: NetworkProtocol
    
    
    // MARK: - Initializer
    
    init(type: BookmarkSearchType) {
        self.initialState = State(type: type)
        self.network = NetworkProvider()
    }
    
    
    // MARK: - Mutate, Reduce
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .entering(let type):
            return Observable.concat([
                Observable.just(.isLoading(true)),
                getBookmarkList(type: type),
                Observable.just(.isLoading(false))
            ])
            
        case .deleteBookmark(let index):
            return deleteBookmark(index: index)
            
        case .removeDeletedBookmark(let id):
            return deleteBookmark(id: id)
            
        case .modifyBookmark(let info):
            return modifyBookmark(info: info)
            
        case .nextPage:
            return Observable.concat([
                Observable.just(.isLoading(true)),
                getBookmarkList(type: currentState.type),
                Observable.just(.isLoading(false))
            ])
            
        case .togglingInfo(let index):
            return toggleBookmarkInfo(index: index)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .fetchBookmarkList(let bookmarkList, let isLastPage):
            newState.page = state.page + 1
            newState.bookmarkList = bookmarkList
            newState.isLastPage = isLastPage
            
        case .modifyBookmarkList(let bookmarkList):
            newState.bookmarkList = bookmarkList
            
        case .toggledInfo(let bookmarkList):
            newState.bookmarkList = bookmarkList
            
        case .isLoading(let isPaging):
            newState.isPaging = isPaging
            
        case .error:
            print("Reactor Error")
            break
        }
        
        return newState
    }
}


// MARK: - Functions

extension BookmarkCardListVM {
    
    func deleteBookmark(id: Int) -> Observable<Mutation> {
        let originBookmarkList = currentState.bookmarkList
        let deletedBookmarkList = originBookmarkList.filter({ $0.id != id })
        
        return Observable.just(.modifyBookmarkList(deletedBookmarkList))
    }
    
    func modifyBookmark(info: BookmarkInfo) -> Observable<Mutation> {
        let card = info.toBookmarkCardModel()
        let type = currentState.type
        var currentBookmarkList = currentState.bookmarkList
        
        switch type {
        case .all:
            currentBookmarkList = currentBookmarkList.map { $0.id == card.id ? card : $0 }
        case .want, .done:
            if type.rawValue == card.groupType {
                currentBookmarkList = currentBookmarkList.map { $0.id == card.id ? card : $0 }
            } else {
                currentBookmarkList = currentBookmarkList.filter { $0.id != card.id }
            }
        }
        
        return Observable.just(.modifyBookmarkList(currentBookmarkList))
    }
    
    func toggleBookmarkInfo(index: Int) -> Observable<Mutation> {
        var bookmarkList = currentState.bookmarkList
        bookmarkList[index].infoHidden.toggle()
        
        return Observable.just(.toggledInfo(bookmarkList))
    }
    
}

// MARK: - Networking

extension BookmarkCardListVM {
    
    func getBookmarkList(type: BookmarkSearchType) -> Observable<Mutation> {
        let page = currentState.page
        let path = "/api/bookmarks?searchType=\(type.rawValue)&page=\(page)&size=10&sort=LATEST"
        let endPoint = EndPoint<BookmarkListResponseModel>(path: path, httpMethod: .get)
        
        return network.request(with: endPoint)
            .withUnretained(self)
            .map { owner, result -> Mutation in
                switch result {
                case .success(let data):
                    let bookmarkList = data.content.map { $0.toBookmarkCardModel() }
                    let originBookmarkList = owner.currentState.bookmarkList
                    let isLastPage = data.last

                    if page == 0 {
                        return .fetchBookmarkList(bookmarkList, isLastPage)
                    } else {
                        return .fetchBookmarkList(originBookmarkList + bookmarkList, isLastPage)
                    }
                case .failure:
                    return .error
                }
            }
    }
    
    func deleteBookmark(index: Int) -> Observable<Mutation> {
        let id = currentState.bookmarkList[index].id
        let path = "/api/bookmarks/\(id)"
        let endPoint = EndPoint<EmptyEntity>(path: path, httpMethod: .delete)
        
        return network.request(with: endPoint)
            .withUnretained(self)
            .map { owner, result -> Mutation in
                switch result {
                case .success:
                    let deletedBookmarkList = owner.currentState.bookmarkList.filter({ $0.id != id })
                    return .modifyBookmarkList(deletedBookmarkList)
                case .failure:
                    return .error
                }
            }
    }
    
}
