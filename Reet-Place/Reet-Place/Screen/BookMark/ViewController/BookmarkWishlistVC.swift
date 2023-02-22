//
//  BookmarkWishlistVC.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/18.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit
import Then

class BookmarkWishlistVC: BaseNavigationViewController {
    
    // MARK: - UI components
    override var alias: String {
        "BookmarkWishlist"
    }
    
    private let filterView = BookmarkFilterView()
    
    private let tableView = UITableView(frame: .zero, style: .plain)
        .then {
            $0.rowHeight = UITableView.automaticDimension
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
        }
    
    private let viewOnMapBtn = ReetFAB(fabSize: .large, title: "지도로 보기", fabImage: .map)
    
    
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

extension BookmarkWishlistVC {
    
    private func configureContentView() {
        title = "가고싶어요"
        navigationBar.style = .left
        
        view.addSubviews([tableView, filterView, viewOnMapBtn])
    }
    
}


// MARK: - Layout

extension BookmarkWishlistVC {
    
    private func configureLayout() {
        filterView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(filterView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        viewOnMapBtn.snp.makeConstraints {
            $0.bottom.equalTo(tableView.snp.bottom).offset(-20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BookmarkCardTVC.self, forCellReuseIdentifier: BookmarkCardTVC.className)
    }
    
}

extension BookmarkWishlistVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        50.0
    }
}

extension BookmarkWishlistVC: UITableViewDataSource {
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
//            tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .automatic)
            tableView.reloadData()
        }
        
        return cell
    }
}
