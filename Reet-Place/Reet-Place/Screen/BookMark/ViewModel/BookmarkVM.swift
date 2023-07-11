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
        private let accessToken = BehaviorRelay(value: KeychainManager.shared.read(for: .accessToken))
        
        var isAuthenticated: Observable<Bool> {
            accessToken.map { $0 != nil }
        }
        
        var isEmptyBookmark: Observable<Bool> {
            BookmarkAllCnt.map { $0 == 0 }
        }
        
        var BookmarkAllCnt = BehaviorRelay<Int>(value: 0)
        
        var BookmarkWishlistInfo = PublishRelay<TypeInfo>()
        
        var BookmarkHistoryInfo = PublishRelay<TypeInfo>()
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
            
            self.output.BookmarkAllCnt.accept(data.bookmarkMainInfo[0].cnt + data.bookmarkMainInfo[1].cnt)
            self.output.BookmarkWishlistInfo.accept(data.bookmarkMainInfo[0])
            self.output.BookmarkHistoryInfo.accept(data.bookmarkMainInfo[1])
        }
    }
    
}
