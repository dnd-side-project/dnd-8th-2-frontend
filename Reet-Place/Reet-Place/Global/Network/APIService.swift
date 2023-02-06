//
//  APIService.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import Alamofire
import RxSwift

protocol APIService {
    
    func getRequest<T: Decodable>(with urlResource: URLResource<T>) -> Observable<Result<T, APIError>>
    
    func postRequest<T: Decodable>(with urlResource: URLResource<T>, param: Parameters?) -> Observable<Result<T, APIError>>
    
    func postRequestWithImage<T: Decodable>(with urlResource: URLResource<T>, param: Parameters, image: UIImage) -> Observable<Result<T, APIError>>
    
}

