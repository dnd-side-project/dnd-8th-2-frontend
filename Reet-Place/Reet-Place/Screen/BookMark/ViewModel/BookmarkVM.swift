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
        output.BookmarkAllCnt.accept(12)
        output.BookmarkWishlistCnt.accept(8)
        output.BookmarkHistoryCnt.accept(4)
    }
    
}
