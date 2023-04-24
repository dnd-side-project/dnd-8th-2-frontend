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
    
    private let stackView = UIStackView()
        .then {
            $0.spacing = .zero
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .vertical
        }
    
    private let loginView = LoginView()
    
    private let userProfileView = UserProfileView()
    
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
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(loginView)
        stackView.addArrangedSubview(userProfileView)
        stackView.addArrangedSubview(tableView)
    }
    
    override func layoutView() {
        super.layoutView()
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
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
                switch menu {
                case .qna:
                    let vc = SubmitQnaVC()
                    
                    owner.navigationController?
                        .pushViewController(vc, animated: true)
                    
                case .servicePolicy:
                    let vc = ServicePolicyVC()
                    
                    owner.navigationController?
                        .pushViewController(vc, animated: true)
                    
                case .privacyPoilcy:
                    let vc = PrivacyPolicyVC()
                    
                    owner.navigationController?
                        .pushViewController(vc, animated: true)
                    
                case .userInfo:
                    let vc = UserInfoVC()
                    vc.viewModel.output.user
                        .accept(owner.viewModel.output.user.value)
                    
                    owner.navigationController?
                        .pushViewController(vc, animated: true)
                    
                case .signout:
                    print("TODO: Go To \(menu.description)")
                }
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
        
        // 로그인 유무
        
        viewModel.output.isAuthenticated
            .withUnretained(self)
            .bind(onNext: { owner, isAuthenticated in
                DispatchQueue.main.async {
                    owner.loginView.isHidden = isAuthenticated
                    owner.userProfileView.isHidden = !isAuthenticated
                }
            })
            .disposed(by: bag)
        
        // 유저 프로필
        
        viewModel.output.user
            .compactMap { $0 }
            .withUnretained(self)
            .bind(onNext: { owner, user in
                DispatchQueue.main.async {
                    owner.userProfileView.configureProfile(with: user)
                }
            })
            .disposed(by: bag)
        
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
