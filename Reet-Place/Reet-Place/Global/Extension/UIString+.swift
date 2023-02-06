//
//  UIString+.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import UIKit

extension String {
    
    /// 인코딩한 string을 반환하는 메서드
    func encodeURL() -> String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    /// 닉네임이 현재 사용자 닉네임인지 확인
    func isMyNickname(targetNickname: String) -> Bool {
        let myNickname = UserDefaults.standard.string(forKey: UserDefaults.Keys.nickname)
        return targetNickname == myNickname ? true : false
    }
    
}
