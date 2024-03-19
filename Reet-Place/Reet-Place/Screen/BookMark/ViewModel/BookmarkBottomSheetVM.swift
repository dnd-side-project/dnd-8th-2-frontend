//
//  BookmarkBottomSheetVM.swift
//  Reet-Place
//
//  Created by 김태현 on 12/3/23.
//

import Foundation

import RxCocoa
import RxSwift

final class BookmarkBottomSheetVM {
    
    // MARK: - Variables and Properties
    
    var input = Input()
    var output = Output()
    
    let network: NetworkProtocol = NetworkProvider()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    struct Input {}
    struct Output {
        var isSuccessDelete: PublishSubject<Bool> = .init()
        var isSuccessModify: PublishSubject<BookmarkInfo> = .init()
        var isSuccessSave: PublishSubject<BookmarkType> = .init()
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

extension BookmarkBottomSheetVM {
    func bindInput() {}
}

// MARK: - Output

extension BookmarkBottomSheetVM {
    func bindOutput() {}
}

// MARK: - Networking

extension BookmarkBottomSheetVM {
    
    func saveBookmark(searchPlaceInfo: SearchPlaceListContent, modifyInfo: BookmarkCardModel) {
        let path = "/api/bookmarks"
        let requestModel = BookmarkSaveRequestModel(
            place: searchPlaceInfo.toBookmarkSavePlace(),
            type: modifyInfo.groupType,
            rate: modifyInfo.starCount,
            people: modifyInfo.withPeople,
            relLink1: modifyInfo.relLink1,
            relLink2: modifyInfo.relLink2,
            relLink3: modifyInfo.relLink3
        )
        let endPoint = EndPoint<BookmarkInfo>(path: path,
                                              httpMethod: .post,
                                              body: requestModel)
        
        network.request(with: endPoint)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let data):
                    let bookmarkType = BookmarkType(rawValue: data.type)
                    owner.output.isSuccessSave.onNext(bookmarkType)
                case .failure(let error):
                    print(error)
                    owner.apiError.onNext(error)
                }
            })
            .disposed(by: bag)
    }
    
    func deleteBookmark(id: Int) {
        let path = "/api/bookmarks/\(id)"
        let endPoint = EndPoint<EmptyEntity>(path: path, httpMethod: .delete)
        
        network.request(with: endPoint)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success:
                    owner.output.isSuccessDelete.onNext(true)
                case .failure(let error):
                    print(error)
                    owner.apiError.onNext(error)
                }
            })
            .disposed(by: bag)
    }
    
    func modifyBookmark(modifyInfo: BookmarkCardModel) {
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
        
        network.request(with: endPoint)
            .withUnretained(self)
            .subscribe { owner, result in
                switch result {
                case .success(let bookmarkInfo):
                    owner.output.isSuccessModify.onNext(bookmarkInfo)
                case .failure(let error):
                    print(error)
                    owner.apiError.onNext(error)
                }
            }
            .disposed(by: bag)
    }
    
}
