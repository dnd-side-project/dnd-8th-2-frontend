//
//  SearchPlaceAction.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2024/02/17.
//

import UIKit
import CoreLocation

/// 장소 검색과 관련된 함수를 정의
protocol SearchPlaceAction {
    
    func getLocationManager() -> CLLocationManager
    
}
