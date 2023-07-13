//
//  APISession.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import Alamofire
import RxSwift

struct APISession: APIService {
    
    // MARK: - Functions
    
    /// Request GET
    func requestGet<T>(urlResource: URLResource<T>) -> Observable<Result<T, APIError>> where T : Decodable {
        Observable<Result<T, APIError>>.create { observer in
            var headers = HTTPHeaders()
            headers.add(.accept("*/*"))
            headers.add(.contentType("application/json"))
            
            let task = AF.request(urlResource.resultURL,
                                  encoding: URLEncoding.default,
                                  headers: headers,
                                  interceptor: AuthInterceptor())
                .validate(statusCode: 200...399)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(.success(data))
                    case .failure:
                        observer.onNext(urlResource.judgeError(statusCode: response.response?.statusCode ?? -1))
                    }
                }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    /// Request POST
    func reqeustPost<T: Decodable>(urlResource: URLResource<T>, param: Parameters?) -> Observable<Result<T, APIError>> {
        Observable<Result<T, APIError>>.create { observer in
            var headers = HTTPHeaders()
            headers.add(.accept("*/*"))
            headers.add(.contentType("application/json"))
            
            let task = AF.request(urlResource.resultURL,
                                  method: .post,
                                  parameters: param,
                                  encoding: JSONEncoding.default,
                                  headers: headers,
                                  interceptor: AuthInterceptor())
                .validate(statusCode: 200...399)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(.success(data))
                    case .failure:
                        observer.onNext(urlResource.judgeError(statusCode: response.response?.statusCode ?? -1))
                    }
                }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    /// Request POST with multipartForm(image)
    func reqeustPostWithImage<T: Decodable>(urlResource: URLResource<T>, param: Parameters, image: UIImage) -> Observable<Result<T, APIError>> {
        Observable<Result<T, APIError>>.create { observer in
            var headers = HTTPHeaders()
            headers.add(.accept("*/*"))
            headers.add(.contentType("application/json"))
            let task = AF.upload(multipartFormData: { (multipart) in
                for (key, value) in param {
                    multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: "\(key)")
                }
                if let imageData = image.jpegData(compressionQuality: 1) {
                    multipart.append(imageData, withName: "picture", fileName: "image.png", mimeType: "image/png")
                }
            }, to: urlResource.resultURL,
                                 method: .post,
                                 headers: headers,
                                 interceptor: AuthInterceptor())
                .validate(statusCode: 200...399)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(.success(data))
                    case .failure:
                        observer.onNext(urlResource.judgeError(statusCode: response.response?.statusCode ?? -1))
                    }
                }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
