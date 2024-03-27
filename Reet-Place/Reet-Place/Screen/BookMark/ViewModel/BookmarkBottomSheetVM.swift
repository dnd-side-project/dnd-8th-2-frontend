//
//  BookmarkBottomSheetVM.swift
//  Reet-Place
//
//  Created by 김태현 on 12/3/23.
//

import RxCocoa
import RxSwift
import ReactorKit

final class BookmarkBottomSheetVM: Reactor {
    
    // MARK: - Properties
    
    enum Action {
        case deleteBookmark(id: Int)
        case modifyBookmark(modifiedInfo: BookmarkCardModel)
        case saveBookmark(searchPlaceInfo: SearchPlaceListContent, modifiedInfo: BookmarkCardModel)
    }
    
    enum Mutation {
        case finishDeletion(Bool)
        case finishModification(modifiedInfo: BookmarkInfo)
        case finishSave(savedType: BookmarkType)
        case error
    }
    
    struct State {
        var isSuccessDelete: Bool = false
        var successModifiedInfo: BookmarkInfo = .empty
        var savedType: BookmarkType = .standard
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
        case .deleteBookmark(let id):
            deleteBookmark(id: id)
            
        case .modifyBookmark(let modifiedInfo):
            modifyBookmark(modifyInfo: modifiedInfo)
            
        case .saveBookmark(let searchPlaceInfo, let modifiedInfo):
            saveBookmark(searchPlaceInfo: searchPlaceInfo, modifiedInfo: modifiedInfo)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .finishDeletion(let isSuccess):
            newState.isSuccessDelete = isSuccess
            
        case .finishModification(let modifiedInfo):
            newState.successModifiedInfo = modifiedInfo
            
        case .finishSave(let savedType):
            newState.savedType = savedType
            
        case .error:
            print("Reactor Error")
            break
        }
        
        return newState
    }
    
}


// MARK: - Networking

private extension BookmarkBottomSheetVM {
    
    func saveBookmark(searchPlaceInfo: SearchPlaceListContent, modifiedInfo: BookmarkCardModel) -> Observable<Mutation> {
        let path = "/api/bookmarks"
        let requestModel = BookmarkSaveRequestModel(
            place: searchPlaceInfo.toBookmarkSavePlace(),
            type: modifiedInfo.groupType,
            rate: modifiedInfo.starCount,
            people: modifiedInfo.withPeople,
            relLink1: modifiedInfo.relLink1,
            relLink2: modifiedInfo.relLink2,
            relLink3: modifiedInfo.relLink3
        )
        let endPoint = EndPoint<BookmarkInfo>(path: path,
                                              httpMethod: .post,
                                              body: requestModel)
        
        return network.request(with: endPoint)
            .map { result -> Mutation in
                switch result {
                case .success(let data):
                    let bookmarkType = BookmarkType(rawValue: data.type)
                    return .finishSave(savedType: bookmarkType)
                case .failure:
                    return .error
                }
            }
    }
    
    func deleteBookmark(id: Int) -> Observable<Mutation> {
        let path = "/api/bookmarks/\(id)"
        let endPoint = EndPoint<EmptyEntity>(path: path, httpMethod: .delete)
        
        return network.request(with: endPoint)
            .map { result -> Mutation in
                switch result {
                case .success:
                    return .finishDeletion(true)
                case .failure:
                    return .error
                }
            }
    }
    
    func modifyBookmark(modifyInfo: BookmarkCardModel) -> Observable<Mutation> {
        let path = "/api/bookmarks/\(modifyInfo.id)"
        let requestModel = BookmarkModifyRequestModel(
            type: modifyInfo.groupType,
            rate: modifyInfo.starCount,
            people: modifyInfo.withPeople,
            relLink1: modifyInfo.relLink1,
            relLink2: modifyInfo.relLink2,
            relLink3: modifyInfo.relLink3
        )
        let endPoint = EndPoint<BookmarkInfo>(path: path,
                                              httpMethod: .put,
                                              body: requestModel)
        
        return network.request(with: endPoint)
            .map { result -> Mutation in
                switch result {
                case .success(let modifiedInfo):
                    return .finishModification(modifiedInfo: modifiedInfo)
                case .failure:
                    return .error
                }
            }
    }
    
}
