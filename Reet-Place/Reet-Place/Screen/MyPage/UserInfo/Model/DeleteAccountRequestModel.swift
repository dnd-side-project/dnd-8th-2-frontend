//
//  DeleteAccountRequestModel.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/11.
//

import Foundation
import Alamofire

// MARK: - DeleteAccount RequestModel

struct DeleteAccountRequestModel{
    let surveyType: DeleteAccountSurveyType
    let description: String
}

// MARK: - Paramters

extension DeleteAccountRequestModel {
    var parameter: Parameters {
        return [
            "surveyType": surveyType,
            "description": description
        ]
    }
}
