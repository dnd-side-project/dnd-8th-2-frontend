//
//  BookmarkCardListVM.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/18.
//

import Foundation
import RxSwift
import RxCocoa

final class BookmarkCardListVM: BaseViewModel {
    
    var input = Input()
    var output = Output()
    
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    struct Input { }
    
    struct Output {
        var cardList: BehaviorRelay<Array<BookmarkCardModel>> = BehaviorRelay(value: [])
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

extension BookmarkCardListVM: Input {
    
    func bindInput() {
        
    }
    
}


// MARK: - Output

extension BookmarkCardListVM: Output {
    
    func bindOutput() {
        
    }
    
}


// MARK: - Networking

extension BookmarkCardListVM {
    
    func getAllList() {
        BookmarkCardModel.allMock() { [weak self] cardList in
            guard let self = self else { return }
            
            let list = self.output.cardList.value + cardList
            
            self.output.cardList.accept(list)
        }
    }
    
    func getWishList() {
        BookmarkCardModel.wishMock() { [weak self] cardList in
            guard let self = self else { return }
            
            let list = self.output.cardList.value + cardList
            
            self.output.cardList.accept(list)
        }
    }
    
    func getHistoryList() {
        BookmarkCardModel.historyMock() { [weak self] cardList in
            guard let self = self else { return }
            
            let list = self.output.cardList.value + cardList
            
            self.output.cardList.accept(list)
        }
    }
    
    
}
