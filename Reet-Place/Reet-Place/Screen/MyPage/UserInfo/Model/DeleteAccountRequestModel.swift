//
//  DeleteAccountRequestModel.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/11.
//

import Alamofire
import Foundation

struct DeleteAccountRequestModel {
    let data: [DeleteAccountModel]
}

extension DeleteAccountRequestModel {
    var parameter: Parameters {
        return [
            "data": data.map { $0.parameter }
        ]
    }
}

