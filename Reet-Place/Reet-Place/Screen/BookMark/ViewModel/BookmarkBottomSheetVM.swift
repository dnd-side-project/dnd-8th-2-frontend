//
//  BookmarkBottomSheetVM.swift
//  Reet-Place
//
//  Created by 김태현 on 12/3/23.
//

import Foundation

import RxCocoa
import RxSwift
import Alamofire

final class BookmarkBottomSheetVM: BaseViewModel {
    
    // MARK: - Variables and Properties
    
    var input = Input()
    var output = Output()
    
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    struct Input {}
    struct Output {
        var isSuccessDelete: PublishSubject<Bool> = .init()
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
    
    func deleteBookmark(id: Int) {
        let path = "/api/bookmarks/\(id)"
        let resource = URLResource<EmptyEntity>(path: path)
        
        requestDeleteBookmark(urlResource: resource)
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
