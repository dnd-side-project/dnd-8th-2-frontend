//
//  BookmarkVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import UIKit

import RxSwift
import RxCocoa
import ReactorKit

import Then
import SnapKit

import Kingfisher

final class BookmarkVC: BaseNavigationViewController, View {
    
    // MARK: - UI components
    
    override var alias: String {
        "Bookmark"
    }
    
    private let bookmarkTypeCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
                
        return collectionView
    }()
    
    private var allBookmarkBtn = AllBookmarkButton(count: 12)
    
    private let emptyBookmarkView = EmptyBookmarkView()
    
    private let requestLoginView = RequestLoginView()
    
    private let induceBookmarkView = InduceBookmarkView()
    
    
    // MARK: - Variables and Properties
    
    private enum Constants {
        static let sectionInset: CGFloat = 20.0
        static let sectionSpacing: CGFloat = 24.0
        static let cellWidth: CGFloat = UIScreen.main.bounds.width - sectionInset * 2
        static let numberOfItems: Int = 2
    }
    
    private let viewModel = BookmarkVM()
    var disposeBag = DisposeBag()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reactor = viewModel
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        removeCache()
        viewModel.action.onNext(.entering)
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
        
        bindBtn()
    }
    
    // MARK: - Bind Reactor
    
    func bind(reactor: BookmarkVM) {
        reactor.state.map { $0.isAuthenticated }
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { owner, isAuthenticated in
                owner.allBookmarkBtn.isHidden = !isAuthenticated
                owner.bookmarkTypeCV.isHidden = !isAuthenticated
                owner.emptyBookmarkView.isHidden = !isAuthenticated
                owner.induceBookmarkView.isHidden = !isAuthenticated
                
                owner.requestLoginView.isHidden = isAuthenticated
            })
            .disposed(by: bag)
        
        reactor.state.map { $0.bookmarkTotalCount }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, count in
                owner.allBookmarkBtn.configureButton(for: count > 0 ? .active : .disabled,
                                                     count: count)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.bookmarkWishInfo }
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { owner, data in
                owner.bookmarkTypeCV.reloadData()
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.bookmarkHistoryInfo }
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { owner, data in
                owner.bookmarkTypeCV.reloadData()
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.bookmarkTotalCount }
            .map { $0 == 0 }
            .distinctUntilChanged()
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { owner, isEmpty in
                owner.bookmarkTypeCV.isHidden = isEmpty
                owner.induceBookmarkView.isHidden = isEmpty
                owner.emptyBookmarkView.isHidden = !isEmpty
            })
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - Functions
    
    // 임시 이미지 캐시 삭제
    private func removeCache() {
        
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache() {
            print("TODO: - 임시 이미지 캐시 삭제 기능 삭제")
        }
        
        ImageCache.default.cleanExpiredMemoryCache()
        ImageCache.default.cleanExpiredDiskCache()
        
    }
    
    private func goToHomeTab() {
        guard let rootVC = UIViewController.getRootViewController(),
              let tabBarVC = rootVC.rootViewController as? ReetPlaceTabBarVC
        else { return }
        
        tabBarVC.activeTabBarItem(targetItemType: .home)
    }
}


// MARK: - Configure

extension BookmarkVC {
    
    private func configureContentView() {
        view.addSubviews([allBookmarkBtn,
                          emptyBookmarkView,
                          requestLoginView,
                          bookmarkTypeCV,
                          induceBookmarkView])
        
        title = "Bookmark".localized
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
            $0.height.equalTo(76.0)
        }
        
        
        emptyBookmarkView.snp.makeConstraints {
            $0.center.equalTo(bookmarkTypeCV.snp.center)
            $0.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        requestLoginView.snp.makeConstraints {
            $0.center.equalTo(bookmarkTypeCV.snp.center)
            $0.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        bookmarkTypeCV.snp.makeConstraints {
            $0.top.equalTo(allBookmarkBtn.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(induceBookmarkView.snp.top).offset(-24.0)
        }
        
        induceBookmarkView.snp.makeConstraints {
            $0.height.equalTo(62.0)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-28.0)
        }
        
        emptyBookmarkView.isHidden = false
        requestLoginView.isHidden = false
        
    }
    
}

// MARK: - Input

extension BookmarkVC {
    
    private func bindBtn() {
        // 북마크 모두 보기
        allBookmarkBtn.rx.tap
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                let bookmarkAllVC = BookmarkListVC(type: .all)
                owner.navigationController?.pushViewController(bookmarkAllVC, animated: true)
            })
            .disposed(by: bag)
        
        // 북마크 하러 가기 버튼
        induceBookmarkView.goBookmarkBtn.rx.tap
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.goToHomeTab()
            })
            .disposed(by: bag)
        
        // 북마크가 없을 때 -> 내 주변 둘러보기 버튼
        emptyBookmarkView.aroundMeBtn.rx.tap
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.goToHomeTab()
            })
            .disposed(by: bag)
    }
    
}


// MARK: - UICollectionViewDelegate

extension BookmarkVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var bookmarkSearchType: BookmarkSearchType = .want
        
        if indexPath.row == 0 {
            guard viewModel.currentState.bookmarkWishInfo.cnt != 0 else { return }
        } else {
            guard viewModel.currentState.bookmarkHistoryInfo.cnt != 0 else { return }
            bookmarkSearchType = .done
        }
        
        let bookmarkListVC = BookmarkListVC(type: bookmarkSearchType)
        navigationController?.pushViewController(bookmarkListVC, animated: true)
    }
    
}

// MARK: - UICollectionViewDataSource

extension BookmarkVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkTypeCVC.className, for: indexPath) as? BookmarkTypeCVC else { return UICollectionViewCell() }
        
        if indexPath.row == 0 {
            cell.configureData(typeInfo: viewModel.currentState.bookmarkWishInfo)
        }
        
        if indexPath.row == 1 {
            cell.configureData(typeInfo: viewModel.currentState.bookmarkHistoryInfo)
        }
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BookmarkVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = collectionView.frame.height / 2 - Constants.sectionInset * 2
        return CGSize(width: Constants.cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = Constants.sectionInset
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.sectionSpacing
    }
    
}
