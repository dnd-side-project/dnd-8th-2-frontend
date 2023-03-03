//
//  HomeVM.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/26.
//

import RxCocoa
import RxSwift

final class HomeVM: BaseViewModel {
    
    // MARK: - Variables and Properties
    
    var input = Input()
    var output = Output()
    
    var apiSession: APIService = APISession()
    let apiError = PublishSubject<APIError>()
    
    var bag = DisposeBag()
    
    struct Input {}
    struct Output {
        var loading = BehaviorRelay<Bool>(value: false)
        
        var isMidnight: BehaviorSubject<Bool> = BehaviorSubject(value: false)
        
        private var placeCategoryList: BehaviorRelay<Array<PlaceCategoryList>> = BehaviorRelay(value: PlaceCategoryList.allCases)
        var placeCategoryDataSources: Observable<Array<PlaceCategoryListDataSource>> {
            placeCategoryList.map { [PlaceCategoryListDataSource(items: $0)] }
        }
    }
    
    // MARK: - Life Cycle
    
    init() {
        bindInput()
        bindOutput()
    }
    
    deinit {
        bag = DisposeBag()
    }
}

// MARK: - Input

extension HomeVM: Input {
    func bindInput() {}
}

// MARK: - Output

extension HomeVM: Output {
    func bindOutput() {}
}

// MARK: - Networking

extension HomeVM {
    
}
