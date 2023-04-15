//
//  BookmarkVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import UIKit

import RxSwift
import RxCocoa

import Then
import SnapKit

class BookmarkVC: BaseNavigationViewController {
    
    // MARK: - UI components
    
    let bookmarkTypeCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
                
        return collectionView
    }()
    
    var allBookmarkBtn = AllBookmarkButton(count: 12)
    
    let emptyBookmarkView = EmptyBookmarkView()
    
    let requestLoginView = RequestLoginView()
    
    let induceBookmarkView = InduceBookmarkView()
    
    override var alias: String {
        "Bookmark"
    }
    
    // MARK: - Variables and Properties
    
    private let viewModel = BookmarkVM()
    
    let cvHeight = ((UIScreen.main.bounds.width - 40) / 2 + 33) * 2 + 40 + 24
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.getBookmarkMock()
    }
    
    override func configureView() {
        super.configureView()
        
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindRx() {
        super.bindRx()
        
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindBtn()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        bindBookmark()
        bindType()
    }
    
    
    // MARK: - Functions
    
}


// MARK: - Configure

extension BookmarkVC {
    
    private func configureContentView() {
        view.addSubviews([allBookmarkBtn,
                          emptyBookmarkView,
                          requestLoginView,
                          bookmarkTypeCV,
                          induceBookmarkView])
        
        title = "북마크"
        navigationBar.style = .default
        
        bookmarkTypeCV.register(BookmarkTypeCVC.self, forCellWithReuseIdentifier: BookmarkTypeCVC.className)
        bookmarkTypeCV.delegate = self
        bookmarkTypeCV.dataSource = self
    }
    
}


// MARK: - Layout

extension BookmarkVC {
    
    private func configureLayout() {
        
        allBookmarkBtn.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(76)
        }
        
        
        emptyBookmarkView.snp.makeConstraints {
            $0.center.equalTo(bookmarkTypeCV.snp.center)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        requestLoginView.snp.makeConstraints {
            $0.center.equalTo(bookmarkTypeCV.snp.center)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        bookmarkTypeCV.snp.makeConstraints {
            $0.top.equalTo(allBookmarkBtn.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(cvHeight)
        }
        
        induceBookmarkView.snp.makeConstraints {
            $0.top.equalTo(bookmarkTypeCV.snp.bottom).offset(24.0)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        emptyBookmarkView.isHidden = false
        requestLoginView.isHidden = false
        
    }
    
}

// MARK: - Input

extension BookmarkVC {
    private func bindBtn() {
        allBookmarkBtn.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                let bookmarkAllVC = BookmarkAllVC()
                self.navigationController?.pushViewController(bookmarkAllVC, animated: true)
            })
            .disposed(by: bag)
        
        induceBookmarkView.goBookmarkBtn.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                guard let root = self.view.window?.rootViewController as? ReetPlaceTabBarVC else { return }
                root.activeTabBarItem(targetItemType: .home)
            })
            .disposed(by: bag)
        
        
    }
}


// MARK: - Output

extension BookmarkVC {
    
    private func bindBookmark() {
        viewModel.output.BookmarkAllCnt
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let allCnt = self.viewModel.output.BookmarkAllCnt.value
                
                self.allBookmarkBtn.configureButton(for: allCnt > 0 ? .active : .disabled,
                                                    count: allCnt)
            })
            .disposed(by: bag)
        
        viewModel.output.BookmarkWishlistCnt
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.bookmarkTypeCV.reloadData()
                }
            })
            .disposed(by: bag)
        
        viewModel.output.BookmarkHistoryCnt
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.bookmarkTypeCV.reloadData()
                }
            })
            .disposed(by: bag)
    }
    
    private func bindType() {
        viewModel.output.isAuthenticated
            .withUnretained(self)
            .bind(onNext: { owner, isAuthenticated in
                DispatchQueue.main.async {
                    owner.allBookmarkBtn.isHidden = !isAuthenticated
                    owner.bookmarkTypeCV.isHidden = !isAuthenticated
                    owner.emptyBookmarkView.isHidden = !isAuthenticated
                    owner.induceBookmarkView.isHidden = !isAuthenticated
                    
                    owner.requestLoginView.isHidden = isAuthenticated
                }
            })
            .disposed(by: bag)
    }
    
}


// MARK: - UICollectionViewDelegate

extension BookmarkVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let bookmarkWishlistVC = BookmarkWishlistVC()
            self.navigationController?.pushViewController(bookmarkWishlistVC, animated: true)
        case 1:
            let bookmarkHistoryVC = BookmarkHistoryVC()
            self.navigationController?.pushViewController(bookmarkHistoryVC, animated: true)
        default:
            let bookmarkAllVC = BookmarkAllVC()
            self.navigationController?.pushViewController(bookmarkAllVC, animated: true)
        }
        
        
    }
    
}

// MARK: - UICollectionViewDataSource

extension BookmarkVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkTypeCVC.className, for: indexPath) as? BookmarkTypeCVC else { return UICollectionViewCell() }
        
        let wishCnt = viewModel.output.BookmarkWishlistCnt.value
        let historyCnt = viewModel.output.BookmarkHistoryCnt.value
        
        if indexPath.row == 0 {
            cell.configureData(type: "wish", count: wishCnt)
        }
        
        if indexPath.row == 1 {
            cell.configureData(type: "visit", count: historyCnt)
        }
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BookmarkVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = UIScreen.main.bounds.width - 40
        let cellHeight = cellWidth / 2 + 33
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let spacingSize = 24
        
        return CGFloat(spacingSize)
    }
    
}
