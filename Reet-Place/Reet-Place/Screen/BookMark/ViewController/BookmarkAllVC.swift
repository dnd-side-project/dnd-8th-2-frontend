//
//  BookmarkAllVC.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/17.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit
import Then

class BookmarkAllVC: BaseNavigationViewController {
    
    // MARK: - UI components
    override var alias: String {
        "BookmarkAll"
    }
    
    private let tableView = UITableView(frame: .zero, style: .plain)
        .then {
            $0.rowHeight = UITableView.automaticDimension
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
        }
    
    // MARK: - Variables and Properties
    
    private let viewModel: BookmarkCardListVM = BookmarkCardListVM()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getWishList()
    }
    
    override func configureView() {
        super.configureView()
        
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Functions
    
    
}


// MARK: - Configure

extension BookmarkAllVC {
    
    private func configureContentView() {
        
        title = "전체보기"
        navigationBar.style = .left
        
        view.addSubview(tableView)
        
    }
    
}


// MARK: - Layout

extension BookmarkAllVC {
    
    private func configureLayout() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BookmarkCardTVC.self, forCellReuseIdentifier: BookmarkCardTVC.className)
        
        
    }
    
}

extension BookmarkAllVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        50.0
    }
}

extension BookmarkAllVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cardList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkCardTVC.className, for: indexPath) as? BookmarkCardTVC else { fatalError("No such Cell") }
        cell.selectionStyle = .none
        
        let cardInfo = viewModel.cardList.value[indexPath.row]
        
        cell.configureCell(with: cardInfo)
        
        cell.toggleAction = {
            var card = self.viewModel.cardList.value
            card[indexPath.row].infoHidden = !card[indexPath.row].infoHidden
            self.viewModel.cardList.accept(card)
            tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .automatic)
        }
        
        return cell
    }
}

