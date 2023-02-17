//
//  Service.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

protocol Service {
    
    var apiSession: APIService { get }
    
}

extension Service {
  var authToken: String? {
    KeychainManager.shared.read(for: .authToken)
  }
}
