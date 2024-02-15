//
//  APIService.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import Alamofire
import RxSwift

protocol APIService {
    
    func requestGet<T: Decodable>(urlResource: URLResource<T>) -> Observable<Result<T, APIError>>
    
    func requestPost<T: Decodable>(urlResource: URLResource<T>, parameter: Parameters?) -> Observable<Result<T, APIError>>
    
    func requestPostWithImage<T: Decodable>(urlResource: URLResource<T>, parameter: Parameters, image: UIImage) -> Observable<Result<T, APIError>>
    
    func requestPut<T: Decodable>(urlResource: URLResource<T>, parameter: Parameters?) -> Observable<Result<T, APIError>>
    
    func requestDelete<T: Decodable>(urlResource: URLResource<T>) -> Observable<Result<T, APIError>>
    
}

