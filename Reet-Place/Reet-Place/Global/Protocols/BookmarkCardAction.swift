//
//  BookmarkCardAction.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/11/28.
//

import UIKit

/// 사용자가 저장한(혹은 할) 북마크와 관련된 작업 등을 정의
protocol BookmarkCardAction {
    
    /// 사용자가 작성한 메모 정보를 보여(토글)주는 함수
    func infoToggle(index: Int)
    
    /// 장소에 대한 추가 작업 목록을 옵션으로 보여주게 하는 함수
    func showMenu(index: Int, location: CGRect, selectMenuType: SelectBoxStyle)
    
    /// 사용자가 작성한 메모에 있는 URL 링크를 웹 브라우저로 띄어주는 함수
    func openRelatedURL(_ urlString: String?)
    
}
