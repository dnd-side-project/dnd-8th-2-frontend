//
//  DeleteAccountModel.swift
//  Reet-Place
//
//  Created by 김태현 on 12/19/23.
//

import Alamofire
import Foundation

struct DeleteAccountModel {
    let surveyType: DeleteAccountSurveyType
    let description: String
}

extension DeleteAccountModel {
    var parameter: Parameters {
        return [
            "surveyType": surveyType.rawValue,
            "description": description
        ]
    }
}
