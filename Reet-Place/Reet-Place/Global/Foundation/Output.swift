//
//  Output.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

protocol Output {
    
    associatedtype Output
    
    var output: Output { get }
    
    func bindOutput()
    
}
