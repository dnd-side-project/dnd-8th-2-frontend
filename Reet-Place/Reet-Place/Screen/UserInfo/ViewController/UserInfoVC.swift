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

class UserInfoVC: BaseNavigationViewController {
    
    // MARK: - UI components
    
    private let userInfoTableView = UITableView(frame: .zero, style: .plain)
        .then {
            $0.rowHeight = UserInfoTVC.defaultHeight
            $0.separatorStyle = .none
            $0.register(UserInfoTVC.self,
                        forCellReuseIdentifier: UserInfoTVC.className)
        }
    
    // MARK: - Variables and Properties
    
    let viewModel = UserInfoVM()
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureNavigationBar()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindUserInfoTableView()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        bindUserInfoTableViewDataSource()
        bindUserInfo()
    }
}

// MARK: - Configure

extension UserInfoVC {
    
    private func configureNavigationBar() {
        navigationBar.style = .left
        title = "UserInfoTitle".localized
    }
    
}

// MARK: - Layout

extension UserInfoVC {
    
    private func configureLayout() {
        view.addSubview(userInfoTableView)
        
        userInfoTableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

// MARK: - Input

extension UserInfoVC {
    
    private func bindUserInfoTableView() {
        userInfoTableView.rx.modelSelected(UserInfoMenu.self)
            .withUnretained(self)
            .bind(onNext: { owner, menu in
                switch menu {
                case .sns:
                    print("Tab \(menu.description)")
                case .delete:
                    let vc = DeleteAccountVC()
                    owner.navigationController?
                        .pushViewController(vc, animated: true)
                }
            })
            .disposed(by: bag)
        
        userInfoTableView.rx.itemSelected
            .withUnretained(self)
            .bind(onNext: { owner, indexPath in
                owner.userInfoTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: bag)
    }
    
}

// MARK: - Output

extension UserInfoVC {
    
    private func bindUserInfoTableViewDataSource() {
        let dataSource = RxTableViewSectionedReloadDataSource<UserInfoMenuDataSource> { [weak self]
            _,
            tableView,
            indexPath,
            menu in
            guard let self = self,
                  let cell = userInfoTableView
                .dequeueReusableCell(withIdentifier: UserInfoTVC.className,
                                     for: indexPath) as? UserInfoTVC else {
                fatalError("No such cells named UserInfoTVC")
            }
            cell.configureUserInfoTVC(infoMenuType: menu, userInformation: viewModel.output.userInformation.value)
            
            return cell
        }
        
        viewModel.output.menuDataSource
            .bind(to: userInfoTableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    private func bindUserInfo() {
        viewModel.output.userInformation
            .withUnretained(self)
            .bind(onNext: { owner, data in
                DispatchQueue.main.async {
                    owner.userInfoTableView.reloadData()
                }
            })
            .disposed(by: bag)
    }
    
}
