//
//  BookmarkVM.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/04/12.
//

import RxCocoa
import RxSwift

final class BookmarkVM: BaseViewModel {
    
    var input = Input()
    var output = Output()
    
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    struct Input { }
    
    struct Output {
        private let authToken = BehaviorRelay(value: KeychainManager.shared.read(for: .authToken))
        
        var isAuthenticated: Observable<Bool> {
            authToken.map { $0 == nil }
        }
        
        var isEmptyBookmark: Observable<Bool> {
            BookmarkAllCnt.map { $0 == 0 }
        }
        
        var BookmarkAllCnt = BehaviorRelay<Int>(value: 0)
        
        var BookmarkWishlistCnt = BehaviorRelay<Int>(value: 0)
        
        var BookmarkHistoryCnt = BehaviorRelay<Int>(value: 0)
    }
    
    init() {
        bindInput()
        bindOutput()
    }
    
    deinit {
        bag = DisposeBag()
    }
    
    
}

// MARK: - Input

extension BookmarkVM: Input {
    func bindInput() { }
}


// MARK: - Ouptut

extension BookmarkVM: Output {
    func bindOutput() { }
}


// MARK: - Networking

extension BookmarkVM {
    
    func getBookmarkMock() {
        BookmarkMainModel.getMock { [weak self] data in
            guard let self = self else { return }
            
            let wishListCnt = data.bookmarkMainInfo[0].cnt
            let historyCnt = data.bookmarkMainInfo[1].cnt
            
            self.output.BookmarkWishlistCnt.accept(wishListCnt)
            self.output.BookmarkHistoryCnt.accept(historyCnt)
            self.output.BookmarkAllCnt.accept(wishListCnt + historyCnt)
        }
    }
    
}
