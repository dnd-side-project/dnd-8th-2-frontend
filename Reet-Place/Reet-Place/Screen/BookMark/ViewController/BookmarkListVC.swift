//
//  BookmarkListVC.swift
//  Reet-Place
//
//  Created by 김태현 on 1/22/24.
//

import SafariServices
import UIKit

import RxSwift
import RxCocoa

import SnapKit
import Then

final class BookmarkListVC: BaseNavigationViewController {
    
    // MARK: - UI components
    
    override var alias: String {
        switch bookmarkType {
        case .all:
            return "BookmarkAll"
        case .want:
            return "BookmarkWishlist"
        case .done:
            return "BookmarkHistory"
        }
    }
    
    private let filterView = BookmarkFilterView()
    
    private let tableView = UITableView(frame: .zero, style: .plain)
        .then {
            $0.rowHeight = UITableView.automaticDimension
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
        }
    
    private let viewOnMapBtn = ReetFAB(size: .extended(.large),
                                       title: "ViewOnMapBtn".localized,
                                       image: .map)
    
    
    // MARK: - Variables and Properties
    
    private let viewModel: BookmarkCardListVM
    private let bookmarkType: BookmarkSearchType
    
    
    // MARK: - Initialize
    
    init(type: BookmarkSearchType) {
        self.bookmarkType = type
        self.viewModel = BookmarkCardListVM(type: type)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.input.page.accept(0)
        viewModel.getBookmarkList(type: bookmarkType)
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
        
        bindButton()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        bindBookmarkAll()
    }
    
    // MARK: - Functions

}

// MARK: - Configure

extension BookmarkListVC {
    
    private func configureContentView() {
        switch bookmarkType {
        case .all:
            title = "BookmarkAll".localized
        case .want:
            title = "BookmarkWishlist".localized
        case .done:
            title = "BookmarkHistory".localized
        }
        
        navigationBar.style = .left
        
        view.addSubviews([tableView, filterView, viewOnMapBtn])
    }
    
}


// MARK: - Layout

extension BookmarkListVC {
    
    private func configureLayout() {
        filterView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(40.0)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(filterView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        viewOnMapBtn.snp.makeConstraints {
            $0.bottom.equalTo(tableView.snp.bottom).offset(-20.0)
            $0.centerX.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BookmarkCardTVC.self, forCellReuseIdentifier: BookmarkCardTVC.className)
    }
    
}


// MARK: - Bind

extension BookmarkListVC {
    
    private func bindButton() {
        viewOnMapBtn.rx.tap
            .withUnretained(self)
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.asyncInstance)
            .bind { owner, _ in
                let bookmarkMapVC = BookmarkMapVC(bookmarkType: owner.bookmarkType)
                bookmarkMapVC.pushWithHidesReetPlaceTabBar()
            }
            .disposed(by: bag)
    }
    
    private func bindBookmarkAll() {
        viewModel.output.bookmarkList
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            .disposed(by: bag)
    }
    
}


// MARK: - UITableViewDelegate

extension BookmarkListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        50.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y > tableView.contentSize.height - tableView.bounds.size.height {
            if !viewModel.output.isPaging.value && !viewModel.output.isLastPage.value {
                viewModel.getBookmarkList(type: bookmarkType)
            }
        }
    }
}


// MARK: - UITableViewDataSource

extension BookmarkListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.output.bookmarkList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkCardTVC.className, for: indexPath) as? BookmarkCardTVC else { fatalError("No such Cell") }
        
        let bookmarkInfo = viewModel.output.bookmarkList.value[indexPath.row]
        cell.configureBookmarkCardTVC(with: bookmarkInfo,
                                      bookmarkCardActionDelegate: self,
                                      index: indexPath.row)
        
        return cell
    }
}


// MARK: - BookmarkCardAction Delegate

extension BookmarkListVC: BookmarkCardAction {
    
    func infoToggle(index: Int) {
        var card = viewModel.output.bookmarkList.value
        card[index].infoHidden.toggle()
        viewModel.output.bookmarkList.accept(card)
        tableView.reloadData()
    }
    
    func showMenu(index: Int, location: CGRect, selectMenuType: SelectBoxStyle) {
        showSelectBox(targetVC: self, location: location, style: .bookmarked) { [weak self] row in
            guard let self = self else { return }
            
            if row == 0 {
                self.showBottomSheet(index: index)
            }
            
            if row == 1 {
                print("TODO: - Copy Link to be call")
            }
            
            if row == 2 {
                self.viewModel.deleteBookmark(index: index)
            }
        }
    }
    
    func openRelatedURL(_ urlString: String?) {
        guard let urlString, let url = URL(string: urlString) else { return }
        let safariVC = SFSafariViewController(url: url)
        
        safariVC.preferredBarTintColor = AssetColors.white
        safariVC.preferredControlTintColor = AssetColors.primary500
        
        present(safariVC, animated: true)
    }
    
    func showBottomSheet(index: Int) {
        let bottomSheetVC = BookmarkBottomSheetVC(isBookmarking: true)
        let cardInfo = viewModel.output.bookmarkList.value[index]
        bottomSheetVC.configureSheetData(with: cardInfo)
        
        bottomSheetVC.deletedBookmarkId
            .withUnretained(self)
            .subscribe { owner, id in
                owner.viewModel.deleteBookmark(id: id)
            }
            .disposed(by: bag)
        
        bottomSheetVC.modifiedBookmarkInfo
            .withUnretained(self)
            .subscribe { owner, bookmarkInfo in
                owner.viewModel.modifyBookmark(info: bookmarkInfo)
            }
            .disposed(by: bag)
                
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        present(bottomSheetVC, animated: false)
    }

}
