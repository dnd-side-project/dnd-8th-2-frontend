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
    
    func reqeustPost<T: Decodable>(urlResource: URLResource<T>, param: Parameters?) -> Observable<Result<T, APIError>>
    
    func reqeustPostWithImage<T: Decodable>(urlResource: URLResource<T>, param: Parameters, image: UIImage) -> Observable<Result<T, APIError>>
    
}

