//
//  BookmarkWishlistVC.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/18.
//

import SafariServices
import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa


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
    
    private let viewOnMapBtn = ReetFAB(size: .extended(.large),
                                       title: "ViewOnMapBtn".localized,
                                       image: .map)
    
    
    // MARK: - Variables and Properties
    
    private let viewModel: BookmarkCardListVM = BookmarkCardListVM(type: .want)
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getBookmarkList(type: .want)
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
        
        bindBookmarkWishList()
    }
    
    // MARK: - Functions
    
    
}


// MARK: - Configure

extension BookmarkWishlistVC {
    
    private func configureContentView() {
        title = "BookmarkWishlist".localized
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

extension BookmarkWishlistVC {
    
    private func bindButton() {
        viewOnMapBtn.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let bookmarkMapVC = BookmarkMapVC(bookmarkType: .want)
                bookmarkMapVC.pushWithHidesReetPlaceTabBar()
            }
            .disposed(by: bag)
    }
    
    private func bindBookmarkWishList() {
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

extension BookmarkWishlistVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        50.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y > tableView.contentSize.height - tableView.bounds.size.height {
            if !viewModel.output.isPaging.value && !viewModel.output.isLastPage.value {
                viewModel.getBookmarkList(type: .want)
            }
        }
    }
}


// MARK: - UITableViewDataSource

extension BookmarkWishlistVC: UITableViewDataSource {
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

extension BookmarkWishlistVC: BookmarkCardAction {
    
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
