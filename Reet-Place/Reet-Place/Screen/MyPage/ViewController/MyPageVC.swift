//
//  MyPageVC.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/16.
//

import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa
import RxDataSources

fileprivate let tableViewCellIdentifier = "myPageMenuTableViewCell"

class MyPageVC: BaseNavigationViewController {
    
    private let viewModel = MyPageViewModel()
    
    private let loginView = LoginView()
    
    private let tableView = UITableView(frame: .zero, style: .plain)
        .then {
            $0.rowHeight = 52.0
            $0.separatorStyle = .none
        }
    
    override var alias: String {
        "MyPage"
    }
    
    override func configureView() {
        super.configureView()
        
        title = "MyPage".localized
        navigationBar.style = .default
        
        view.addSubview(loginView)
        view.addSubview(tableView)
    }
    
    override func layoutView() {
        super.layoutView()
        
        loginView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(loginView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.register(DefaultCategoryTVC.self,
                           forCellReuseIdentifier: tableViewCellIdentifier)
    }
    
    override func bindDependency() {
        super.bindDependency()
    }
    
    override func bindInput() {
        super.bindInput()
        
        loginView.loginButton.rx.tap
            .bind(onNext: {
                print("TODO: Do Login")
            })
            .disposed(by: bag)
        
        tableView.rx.modelSelected(MyPageMenu.self)
            .withUnretained(self)
            .bind(onNext: { owner, menu in
                print("TODO: Go To \(menu.description)")
            })
            .disposed(by: bag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .bind(onNext: { owner, indexPath in
                owner.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: bag)
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        // Bind menu
        
        let dataSource = RxTableViewSectionedReloadDataSource<MyPageMenuDataSource> { _,
            tableView,
            indexPath,
            menu in
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: tableViewCellIdentifier,
                                     for: indexPath) as? DefaultCategoryTVC else {
                fatalError("No such cells named DefaultCategoryTVC")
            }
            
            cell.titleLabel.text = menu.description
            cell.titleLabel.textColor = menu.foregroundColor
            
            return cell
        }
        
        viewModel.output.mypageMenuDataSources
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
}
