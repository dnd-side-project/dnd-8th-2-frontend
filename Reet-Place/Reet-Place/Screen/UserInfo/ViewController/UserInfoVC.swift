//
//  UserInfoVC.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/17.
//

import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa
import RxDataSources

fileprivate let userInfoTableViewCellIdentifier = "userInfoTableViewCellIdentifier"

class UserInfoVC: BaseNavigationViewController {
    
    let viewModel = UserInfoViewModel()
    
    private let tableView = UITableView(frame: .zero, style: .plain)
        .then {
            $0.separatorStyle = .none
            $0.rowHeight = UserInfoTVC.defaultHeight
        }
    
    override func configureView() {
        super.configureView()
        
        navigationBar.style = .left
        title = "UserInfoTitle".localized
        
        tableView.register(UserInfoTVC.self, forCellReuseIdentifier: userInfoTableViewCellIdentifier)
    }
    
    override func layoutView() {
        super.layoutView()
        
        // Table View
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func bindDependency() {
        super.bindDependency()
    }
    
    override func bindInput() {
        super.bindInput()
        
        // Table View
        tableView.rx.itemSelected
            .withUnretained(self)
            .bind(onNext: { owner, indexPath in
                owner.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: bag)
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        // DataSource
        let dataSource = RxTableViewSectionedReloadDataSource<UserInfoMenuDataSource> { [weak self]
            _,
            tableView,
            indexPath,
            menu in
            guard let self = self,
                  let cell = tableView
                .dequeueReusableCell(withIdentifier: userInfoTableViewCellIdentifier,
                                     for: indexPath) as? UserInfoTVC else {
                fatalError("No such cells named DefaultCategoryTVC")
            }
            
            cell.titleLabel.text = menu.description
            cell.titleLabel.textColor = menu.foregroundColor
            
            switch menu {
            case .sns:
                cell.infoLabel.text = self.viewModel.output.email
            case .delete:
                cell.rightImageView.isHidden = true
            }
            
            return cell
        }
        
        viewModel.output.menuDataSource
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        // User
        viewModel.output.user
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                DispatchQueue.main.async {
                    owner.tableView.reloadData()
                }
            })
            .disposed(by: bag)
    }
}
