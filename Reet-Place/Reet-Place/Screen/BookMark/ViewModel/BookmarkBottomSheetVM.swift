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
        let resource = URLResource<BookmarkInfo>(path: path)
        let requestModel = BookmarkSaveRequestModel(
            place: searchPlaceInfo.toBookmarkSavePlace(),
            type: modifyInfo.groupType,
            rate: modifyInfo.starCount,
            people: modifyInfo.withPeople,
            relLink1: modifyInfo.relLink1,
            relLink2: modifyInfo.relLink2,
            relLink3: modifyInfo.relLink3
        )
        
        requestSaveBookmark(urlResource: resource, parameter: requestModel)
            .withUnretained(self)
            .subscribe(onNext: { owner, result in
                switch result {
                case .success(let data):
                    let bookmarkType = BookmarkType(rawValue: data.type) ?? .standard
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
    
    func modifyBookmark(modifyInfo: BookmarkCardModel) {
        let path = "/api/bookmarks/\(modifyInfo.id)"
        let resource = URLResource<BookmarkInfo>(path: path)
        let requestModel = BookmarkModifyRequestModel(
            type: modifyInfo.groupType,
            rate: modifyInfo.starCount,
            people: modifyInfo.withPeople,
            relLink1: modifyInfo.relLink1,
            relLink2: modifyInfo.relLink2,
            relLink3: modifyInfo.relLink3
        )
        
        requestModifyBookmark(urlResource: resource, parameter: requestModel.parameter)
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
    
    private func requestModifyBookmark<T>(urlResource: URLResource<T>, parameter: Parameters?) -> Observable<Result<T, APIError>> where T : Decodable {
        Observable<Result<T, APIError>>.create { observer in
            var headers = HTTPHeaders()
            headers.add(.accept("*/*"))
            headers.add(.contentType("application/json"))
            
            let task = AF.request(urlResource.resultURL,
                                  method: .put,
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
    
    private func requestSaveBookmark<T>(urlResource: URLResource<T>, parameter: Encodable) -> Observable<Result<T, APIError>> where T : Decodable {
        Observable<Result<T, APIError>>.create { observer in
            var headers = HTTPHeaders()
            headers.add(.accept("*/*"))
            headers.add(.contentType("application/json"))
            
            let task = AF.request(urlResource.resultURL,
                                  method: .post,
                                  parameters: parameter,
                                  encoder: JSONParameterEncoder.default,
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
