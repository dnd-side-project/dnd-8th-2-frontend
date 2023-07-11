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
    
    override var alias: String {
        "MyPage"
    }
    
    // MARK: - UI components
    
    private let baseStackView = UIStackView()
        .then {
            $0.spacing = .zero
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .vertical
        }
    private let loginView = LoginView()
    private let userProfileView = UserProfileView()
    private let menuTableView = UITableView(frame: .zero, style: .plain)
        .then {
            $0.rowHeight = 52.0
            $0.separatorStyle = .none
            
            $0.register(DefaultCategoryTVC.self,
                        forCellReuseIdentifier: tableViewCellIdentifier)
        }
    
    // MARK: - Variables and Properties
    
    private let viewModel = MyPageVM()
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureNavigationBar()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindDependency() {
        super.bindDependency()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindButton()
        bindMenuTableView()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        bindUserLoginStatus()
        bindMenuTableViewDataSource()
    }
    
}

// MARK: - Configure

extension MyPageVC {
    
    private func configureNavigationBar() {
        title = "MyPage".localized
        navigationBar.style = .default
    }
    
}

// MARK: - Layout

extension MyPageVC {
    
    private func configureLayout() {
        // Add Subviews
        view.addSubview(baseStackView)
        baseStackView.addArrangedSubview(loginView)
        baseStackView.addArrangedSubview(userProfileView)
        baseStackView.addArrangedSubview(menuTableView)
        
        // Make Constraints
        baseStackView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

// MARK: - Input

extension MyPageVC {
    
    private func bindButton() {
        loginView.loginButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                
                let vc = LoginVC()
                vc.delegateLogin = self
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            })
            .disposed(by: bag)
    }
    
    private func bindMenuTableView() {
        menuTableView.rx.modelSelected(MyPageMenu.self)
            .withUnretained(self)
            .bind(onNext: { owner, menu in
                switch menu {
                case .userInfo:
                    let vc = UserInfoVC()
                    vc.viewModel.output.userInformation
                        .accept(owner.viewModel.output.userInfomation.value)
                    
                    owner.navigationController?
                        .pushViewController(vc, animated: true)
                    
                case .qna, .servicePolicy, .privacyPoilcy:
                    let vc = menu.createVC()
                    
                    owner.navigationController?
                        .pushViewController(vc, animated: true)
                    
                case .signout:
                    let alert = UIAlertController(title: .empty,
                                                  message: "LogoutAlert".localized,
                                                  preferredStyle: .actionSheet)

                    let defaultAction = UIAlertAction(title: "Yes".localized, style: .default) { _ in
                        print("TODO: - Sign Out API to be call")
                    }

                    let cancelAction = UIAlertAction(title: "No".localized, style: .cancel)

                    [defaultAction, cancelAction].forEach {
                        alert.addAction($0)
                        $0.setValue(AssetColors.black, forKey: "titleTextColor")
                    }

                    owner.present(alert, animated: true)
                }
            })
            .disposed(by: bag)
        
        menuTableView.rx.itemSelected
            .withUnretained(self)
            .bind(onNext: { owner, indexPath in
                owner.menuTableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: bag)
    }
    
}

// MARK: - Output

extension MyPageVC {
    
    private func bindUserLoginStatus() {
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
        viewModel.output.userInfomation
            .compactMap { $0 }
            .withUnretained(self)
            .bind(onNext: { owner, userInfo in
                DispatchQueue.main.async {
                    owner.userProfileView.configureProfile(userInfo: userInfo)
                }
            })
            .disposed(by: bag)
    }
    
    private func bindMenuTableViewDataSource() {
        let dataSource = RxTableViewSectionedReloadDataSource<MyPageMenuDataSource> { _,
            tableView,
            indexPath,
            menu in
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: tableViewCellIdentifier,
                                     for: indexPath) as? DefaultCategoryTVC else {
                fatalError("No such cells named DefaultCategoryTVC")
            }
            
            cell.configureDefaultCategoryTVC(myPageMenuType: menu)
            
            return cell
        }
        
        viewModel.output.mypageMenuDataSources
            .bind(to: menuTableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
}

// MARK: - Login Action Delegate

extension MyPageVC: LoginAction {
    
    func loginSuccess() {
        viewModel.output.accessToken.accept(KeychainManager.shared.read(for: .accessToken))
        viewModel.output.userInfomation.accept(UserInfomation.getUserInfo())
    }
    
}
