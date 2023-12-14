//
//  BookmarkModifyRequestModel.swift
//  Reet-Place
//
//  Created by 김태현 on 12/3/23.
//

import Foundation
import Alamofire

struct BookmarkModifyRequestModel: Encodable {
    let type: String
    let rate: Int
    let people: String?
    let relLink1: String?
    let relLink2: String?
    let relLink3: String?
}

// MARK: - Parameters

extension BookmarkModifyRequestModel {
    var parameter: Parameters {
        var base: [String: Any] = [
            "type": type,
            "rate": rate
        ]
        
        if let people, !people.isEmpty { base.updateValue(people, forKey: "people") }
        if let relLink1, !relLink1.isEmpty { base.updateValue(relLink1, forKey: "relLink1") }
        if let relLink2, !relLink2.isEmpty { base.updateValue(relLink2, forKey: "relLink2") }
        if let relLink3, !relLink3.isEmpty { base.updateValue(relLink3, forKey: "relLink3") }
        
        return base
    }
}
