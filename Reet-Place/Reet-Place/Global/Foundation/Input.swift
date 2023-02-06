//
//  Input.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

protocol Input {
    
    associatedtype Input
    
    var input: Input { get }
    
    func bindInput()
    
}
