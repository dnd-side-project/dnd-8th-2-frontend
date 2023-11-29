//
//  BookmarkCardListVM.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/18.
//

import Foundation
import RxSwift
import RxCocoa

import Alamofire

final class BookmarkCardListVM: BaseViewModel {
    
    var input = Input()
    var output = Output()
    
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    struct Input {
        var page: BehaviorRelay<Int> = BehaviorRelay(value: 0)
        let size: Int = 20
    }
    
    struct Output {        
        var bookmarkList: BehaviorRelay<Array<BookmarkCardModel>> = BehaviorRelay(value: [])
        var isPaging: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        var isLastPage: BehaviorRelay<Bool> = BehaviorRelay(value: false)
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
    
    func getBookmarkList(type: BookmarkSearchType) {
        let page = input.page.value
        let path = "/api/bookmarks?searchType=\(type.rawValue)&page=\(page)&size=20&sort=LATEST"
        let resource = URLResource<BookmarkListResponseModel>(path: path)
        
        output.isPaging.accept(true)
        apiSession.requestGet(urlResource: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let data):
                    let bookmarkList = data.content.map { $0.toBookmarkCardModel() }
                    let originBookmarkList = owner.output.bookmarkList.value
                    
                    owner.output.isLastPage.accept(data.last)
                    owner.input.page.accept(page + 1)
                    owner.output.bookmarkList.accept(originBookmarkList + bookmarkList)
                case .failure(let error):
                    owner.apiError.onNext(error)
                }
                owner.output.isPaging.accept(false)
            })
            .disposed(by: bag)
    }
    
    /// 릿플 서버에 북마크 리스트 조회 요청
    private func requestGetBookmarkList<T: Decodable>(urlResource: URLResource<T>, parameter: Parameters?) -> Observable<Result<T, APIError>> {
        Observable<Result<T, APIError>>.create { observer in
            var headers = HTTPHeaders()
            headers.add(.accept("*/*"))
            headers.add(.contentType("application/json"))
            
            let task = AF.request(urlResource.resultURL,
                                  method: .post,
                                  parameters: parameter,
                                  encoding: JSONEncoding.default,
                                  headers: headers,
                                  interceptor: AuthInterceptor())
                .validate(statusCode: 200...399)
                .responseDecodable(of: T.self) { response in
                    debugPrint(response)
                    switch response.result {
                    case .success(let data):
                        observer.onNext(.success(data))
                        
                    case .failure(let error):
                        dump(error)
                        guard let error = response.response else { return }
                        observer.onNext(urlResource.judgeError(statusCode: error.statusCode))
                    }
                }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func deleteBookmark(index: Int) {
        let id = output.bookmarkList.value[index].id
        let path = "/api/bookmarks/\(id)"
        let resource = URLResource<EmptyEntity>(path: path)
        
        requestDeleteBookmark(urlResource: resource)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success:
                    let deletedBookmarkList = owner
                        .output.bookmarkList.value
                        .filter({ $0.id != id })
                    owner.output.bookmarkList.accept(deletedBookmarkList)
                case .failure(let error):
                    print(error)
                    owner.apiError.onNext(error)
                }
            })
            .disposed(by: bag)
    }
    
    /// 릿플 서버에 해당 북마크 취소 요청
    private func requestDeleteBookmark<T: Decodable>(urlResource: URLResource<T>) -> Observable<Result<T, APIError>> {
        Observable<Result<T, APIError>>.create { observer in
            var headers = HTTPHeaders()
            headers.add(.accept("*/*"))
            headers.add(.contentType("application/json"))
            
            let task = AF.request(urlResource.resultURL,
                                  method: .delete,
                                  encoding: JSONEncoding.default,
                                  headers: headers,
                                  interceptor: AuthInterceptor())
                .validate(statusCode: 200...399)
                .responseDecodable(of: T.self) { response in
                    debugPrint(response)
                    switch response.result {
                    case .success(let data):
                        observer.onNext(.success(data))
                        
                    case .failure(let error):
                        dump(error)
                        guard let error = response.response else { return }
                        observer.onNext(urlResource.judgeError(statusCode: error.statusCode))
                    }
                }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
