//
//  Loadable.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import RxCocoa

protocol Lodable {
    
    var loading: BehaviorRelay<Bool> { get }
    
}

extension Lodable {
    
    var isLoading: Bool {
        loading.value
    }
    
    func beginLoading() {
        loading.accept(true)
    }
    
    func endLoading() {
        loading.accept(false)
    }
    
}
