//
//  BaseViewModel.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import RxSwift

protocol BaseViewModel: Input, Output {
        
    var bag: DisposeBag { get }
    
}
