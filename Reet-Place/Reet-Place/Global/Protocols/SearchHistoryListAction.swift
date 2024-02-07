//
//  SearchHistoryListAction.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/12/18.
//

import UIKit

/// SearchHistoryTVC와 관련된 작업 등을 정의
protocol SearchHistoryListAction {
    
    /// 검색기록 키워드를 클릭했을 때 호출
    func didTapKeyword(keyword: String)
    
}
