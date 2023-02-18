//
//  BookmarkCardModel.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/18.
//

import Foundation

struct BookmarkCardModel {
    var placeName: String
    var categoryName: String
    var starCount: Int
    var address: String
    var groupType: String
    var infoCount: Int
    var withPeople: String
    var relatedUrl: [String]
    var infoHidden: Bool = true
}

extension BookmarkCardModel {
    
    static func mock(_ completion: @escaping((Array<BookmarkCardModel>) -> Void)) {
        completion([
            BookmarkCardModel(placeName: "미쁘동", categoryName: "식도락", starCount: 3, address: "서울 마포구 동교로38길 33-21 2층", groupType: "가고싶어요", infoCount: 3, withPeople: "신영 나은", relatedUrl: ["https://pf.kakao.com/_SxfBCT", "https://blog.naver.com/fofori123/222995635405"]),
            BookmarkCardModel(placeName: "카페 레이어드 연남점", categoryName: "카페", starCount: 3, address: "서울 마포구 성미산로 161-4", groupType: "가고싶어요", infoCount: 2, withPeople: "훈성 재욱", relatedUrl: ["https://www.instagram.com/cafe_layered/"]),
            BookmarkCardModel(placeName: "작당모의", categoryName: "카페", starCount: 2, address: "서울 마포구 동교로32길 19 1층", groupType: "가고싶어요", infoCount: 2, withPeople: "태현 희재 철우", relatedUrl: ["https://www.instagram.com/zakdangmoi/"]),
            BookmarkCardModel(placeName: "명동교자 본점", categoryName: "식도락", starCount: 3, address: "서울 중구 명동10길 29", groupType: "가고싶어요", infoCount: 3, withPeople: "태현", relatedUrl: ["http://www.mdkj.co.kr/", "https://blog.naver.com/alouete/223012450157"]),
            BookmarkCardModel(placeName: "미쁘동", categoryName: "식도락", starCount: 3, address: "서울 마포구 동교로38길 33-21 2층", groupType: "가고싶어요", infoCount: 3, withPeople: "태현", relatedUrl: ["https://pf.kakao.com/_SxfBCT", "https://blog.naver.com/fofori123/222995635405"]),
            BookmarkCardModel(placeName: "카페 레이어드 연남점", categoryName: "카페", starCount: 3, address: "서울 마포구 성미산로 161-4", groupType: "가고싶어요", infoCount: 2, withPeople: "태현", relatedUrl: ["https://www.instagram.com/cafe_layered/"]),
            BookmarkCardModel(placeName: "작당모의", categoryName: "카페", starCount: 2, address: "서울 마포구 동교로32길 19 1층", groupType: "가고싶어요", infoCount: 2, withPeople: "태현", relatedUrl: ["https://www.instagram.com/zakdangmoi/"]),
            BookmarkCardModel(placeName: "명동교자 본점", categoryName: "식도락", starCount: 3, address: "서울 중구 명동10길 29", groupType: "가고싶어요", infoCount: 3, withPeople: "태현", relatedUrl: ["http://www.mdkj.co.kr/", "https://blog.naver.com/alouete/223012450157"])
        ])
    }
}
