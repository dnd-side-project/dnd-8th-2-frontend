//
//  ReetSelectBox.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/06/01.
//

import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa
import RxGesture

class ReetSelectBox: BaseViewController {
    
    // MARK: - UI components
    
    private let backgroundView: UIView = UIView()
        .then {
            $0.backgroundColor = .clear
        }
    
    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
        .then {
            $0.rowHeight = UITableView.automaticDimension
            $0.layer.cornerRadius = 5.0
            $0.isScrollEnabled = false
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
        }
    
    
    // MARK: - Variables and Properties
    
    var location: CGRect?
    
    var firstAction: (() -> Void)?
    var secondAction: (() -> Void)?
    var thirdAction: (() -> Void)?
    

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureView() {
        super.configureView()
        
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindView()
    }
    
    // MARK: - Functions
    
}


// MARK: - Configure

extension ReetSelectBox {
    
    private func configureContentView() {
        view.backgroundColor = UIColor.clear
        
        view.addSubviews([backgroundView, tableView])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SelectBoxTVC.self, forCellReuseIdentifier: SelectBoxTVC.className)
    }
    
}


// MARK: - Layout

extension ReetSelectBox {
    
    private func configureLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.height.equalTo(150.0)
            $0.width.equalTo(100.0)
            $0.top.equalToSuperview().offset((location?.origin.y ?? 0.0) + 50.0)
            $0.trailing.equalToSuperview().offset(-(screenWidth - (location?.maxX ?? 0.0)))
        }
    }
    
}


// MARK: - Bind

extension ReetSelectBox {
    
    private func bindView() {
        backgroundView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.dismiss(animated: false)
            })
            .disposed(by: bag)
    }
    
}


// MARK: - UITableViewDelegate

extension ReetSelectBox: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        54.0
    }
}


// MARK: - UITableViewDataSource

extension ReetSelectBox: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectBoxTVC.className, for: indexPath) as? SelectBoxTVC else { fatalError("No such Cell") }
        
        return cell
    }
}
