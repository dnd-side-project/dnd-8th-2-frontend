//
//  BookmarkVM.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/04/12.
//

import RxCocoa
import RxSwift

final class BookmarkVM {
    
    var input = Input()
    var output = Output()
    
    let network: NetworkProtocol = NetworkProvider()
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
        
        var BookmarkWishlistInfo = BehaviorRelay<TypeInfo>(value: .init(type: "WANT", cnt: 0, thumbnailUrlString: ""))
        
        var BookmarkHistoryInfo = BehaviorRelay<TypeInfo>(value: .init(type: "GONE", cnt: 0, thumbnailUrlString: ""))
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
//        BookmarkMainModel.getMock { [weak self] data in
//            guard let self = self else { return }
//            
//            self.output.BookmarkAllCnt.accept(data.bookmarkMainInfo[0].cnt + data.bookmarkMainInfo[1].cnt)
//            self.output.BookmarkWishlistInfo.accept(data.bookmarkMainInfo[0])
//            self.output.BookmarkHistoryInfo.accept(data.bookmarkMainInfo[1])
//        }
//        
        // TODO: - 북마크 종류 별 정보 조회 API 수정 시 복구
        getBookmarkList(type: .want)
        getBookmarkList(type: .done)
    }
    
    /// 서버에 북마크 개수 요청
    func getBookmarkCount() {
        let path = "/api/bookmarks/counts"
        let endPoint = EndPoint<BookmarkCountResponseModel>(path: path, httpMethod: .get)
        
        network.request(with: endPoint)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let data):
                    owner.output.BookmarkAllCnt.accept(data.numOfAll)
                    owner.output.BookmarkHistoryInfo
                        .accept(TypeInfo(type: "GONE",
                                         cnt: data.numOfDone,
                                         thumbnailUrlString: "https://picsum.photos/600/400"))
                    owner.output.BookmarkWishlistInfo
                        .accept(TypeInfo(type: "WANT",
                                         cnt: data.numOfWant,
                                         thumbnailUrlString: "https://picsum.photos/600/400"))
                case .failure(let error):
                    owner.apiError.onNext(error)
                }
            })
            .disposed(by: bag)
    }
    
    // TODO: - 북마크 종류 별 정보 조회 API 수정 시 제거
    /// 가고싶어요, 다녀왔어요 북마크를 1 페이지 씩 조회해 존재 여부 확인
    func getBookmarkList(type: BookmarkSearchType) {
        let page = 0
        let path = "/api/bookmarks?searchType=\(type.rawValue)&page=\(page)&size=10&sort=LATEST"
        let endPoint = EndPoint<BookmarkListResponseModel>(path: path, httpMethod: .get)
        
        network.request(with: endPoint)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let data):
                    let isExist: Bool = !data.content.isEmpty
                    
                    if type == .want {
                        if isExist { owner.output.BookmarkAllCnt.accept(100) }
                        owner.output.BookmarkWishlistInfo
                            .accept(.init(type: "WANT",
                                          cnt: isExist ? 100 : 0,
                                          thumbnailUrlString: "https://picsum.photos/600/400"))
                    } else if type == .done {
                        if isExist { owner.output.BookmarkAllCnt.accept(100) }
                        owner.output.BookmarkHistoryInfo
                            .accept(.init(type: "GONE",
                                          cnt: isExist ? 100 : 0,
                                          thumbnailUrlString: "https://picsum.photos/600/300"))
                    }
                case .failure(let error):
                    owner.apiError.onNext(error)
                }
            })
            .disposed(by: bag)
    }
}
