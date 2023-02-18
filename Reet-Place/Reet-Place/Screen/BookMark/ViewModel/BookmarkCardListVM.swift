//
//  BookmarkCardListVM.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/18.
//

import Foundation
import RxSwift
import RxCocoa

final class BookmarkCardListVM {
    
    var cardList: BehaviorRelay<Array<BookmarkCardModel>> = BehaviorRelay(value: [])
    
    func getWishList() {
        BookmarkCardModel.mock() { [weak self] cardList in
            guard let self = self else { return }
            
            let list = self.cardList.value + cardList
            
            self.cardList.accept(list)
        }
    }
    
}
