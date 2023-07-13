//
//  EmptyEntity.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/11.
//

import Alamofire

/// POST 통신 후 Success Response 값이 비어(empty) 있는 (혹은 없는) 경우(ex. Status Code [204, 205]) 채택
///  - usage example : URLResource<EmptyEntity>
struct EmptyEntity: Codable, EmptyResponse {
    static func emptyValue() -> EmptyEntity {
        return EmptyEntity.init()
    }
}
