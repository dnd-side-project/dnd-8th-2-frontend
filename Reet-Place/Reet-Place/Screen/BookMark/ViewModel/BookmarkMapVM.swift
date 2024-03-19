//
//  BookmarkMapVM.swift
//  Reet-Place
//
//  Created by 김태현 on 12/13/23.
//

import Foundation
import RxSwift
import RxCocoa

final class BookmarkMapVM {
    
    // MARK: - Variables and Properties
    
    var input = Input()
    var output = Output()
    
    let network: NetworkProtocol = NetworkProvider()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    struct Input {}
    struct Output {
        var bookmarkSummaries: BehaviorRelay<[BookmarkSummaryModel]> = BehaviorRelay(value: [])
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

extension BookmarkMapVM {
    func bindInput() {}
}

// MARK: - Output

extension BookmarkMapVM {
    func bindOutput() {}
}

// MARK: - Networking

extension BookmarkMapVM {
    
    func getBookmarkSummaries(type: BookmarkSearchType) {
        let path = "/api/bookmarks/all/summaries?searchType=\(type.rawValue)"
        let endPoint = EndPoint<BookmarkSummaryListResponseModel>(path: path, httpMethod: .get)
        
        network.request(with: endPoint)
            .withUnretained(self)
            .subscribe { owner, result in
                switch result {
                case .success(let summariesReponse):
                    let summaries = summariesReponse.map { $0.toSummary() }
                    owner.output.bookmarkSummaries.accept(summaries)
                case .failure(let error):
                    owner.apiError.onNext(error)
                }
            }
            .disposed(by: bag)
    }
    
}
