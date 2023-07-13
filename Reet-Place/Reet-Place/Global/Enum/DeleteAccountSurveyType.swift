//
//  DeleteAccountSurveyType.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/11.
//

import Foundation

enum DeleteAccountSurveyType: String {
    // 기록 삭제 목적
    case recordDelete = "RECORD_DELETE"
    
    // 사용 빈도가 낮아서
    case lowUsed = "LOW_USED"
    
    // 다른 서비스 사용 목적
    case useOtherService = "USE_OTHER_SERVICE"
    
    // 이용이 불편하고 장애가 많아서
    case inconvenienceAndErrors = "INCONVENIENCE_AND_ERRORS"
    
    // 콘텐츠 불만
    case contentDissatisfaction = "CONTENT_DISSATISFACTION"
    
    // 기타
    case other = "OTHER"
}
