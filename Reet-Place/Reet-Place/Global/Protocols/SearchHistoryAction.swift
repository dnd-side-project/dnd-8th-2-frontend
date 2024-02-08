//
//  SearchHistoryAction.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/12/18.
//

import UIKit

/// SearchHistoryTVC와 관련된 작업 등을 정의
protocol SearchHistoryAction {
    
    /// 개별 검색기록 지우기 버튼을 클릭했을 때 호출
    func didTapRemoveKeywordButton(searchHistoryContent: SearchHistoryContent)
    
}
