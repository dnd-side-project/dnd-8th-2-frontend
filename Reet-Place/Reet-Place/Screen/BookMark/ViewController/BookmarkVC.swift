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

import Kingfisher

class BookmarkVC: BaseNavigationViewController {
    
    // MARK: - UI components
    
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
    
    override var alias: String {
        "Bookmark"
    }
    
    
    // MARK: - Variables and Properties
    
    private let viewModel = BookmarkVM()
    
    let cvHeight = ((UIScreen.main.bounds.width - 40) / 2 + 33) * 2 + 40 + 24
    
    var wishListInfo: TypeInfo?
    var historyInfo: TypeInfo?
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        removeCache()
        
        // TODO: - 서버 에러 해결 후 변경
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


// MARK: - Output

extension BookmarkVC {
    
    private func bindBookmark() {
        // 북마크 All 개수
        viewModel.output.BookmarkAllCnt
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let allCnt = owner.viewModel.output.BookmarkAllCnt.value
                
                owner.allBookmarkBtn.configureButton(for: allCnt > 0 ? .active : .disabled,
                                                     count: allCnt)
            })
            .disposed(by: bag)
        
        // 북마크 - 가고싶어요 개수, 이미지
        viewModel.output.BookmarkWishlistInfo
            .withUnretained(self)
            .subscribe(onNext: { owner, data in
                owner.wishListInfo = data
                
                DispatchQueue.main.async {
                    owner.bookmarkTypeCV.reloadData()
                }
            })
            .disposed(by: bag)
        
        // 북마크 - 다녀왔어요 개수, 이미지
        viewModel.output.BookmarkHistoryInfo
            .withUnretained(self)
            .subscribe(onNext: { owner, data in
                owner.historyInfo = data
                
                DispatchQueue.main.async {
                    owner.bookmarkTypeCV.reloadData()
                }
            })
            .disposed(by: bag)
    }
    
    private func bindType() {
        // 로그인 여부 체크
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
        
        // 북마크 개수가 0개인지 확인
        viewModel.output.isEmptyBookmark
            .withUnretained(self)
            .bind(onNext: { owner, isEmptyBookmark in
                DispatchQueue.main.async {
                    owner.bookmarkTypeCV.isHidden = isEmptyBookmark
                    owner.induceBookmarkView.isHidden = isEmptyBookmark
                    owner.emptyBookmarkView.isHidden = !isEmptyBookmark
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
        guard let wishListInfo = wishListInfo,
              let historyInfo = historyInfo else { return }
        
        var bookmarkSearchType: BookmarkSearchType = .want
        
        if indexPath.row == 0 {
            guard wishListInfo.cnt != 0 else { return }
        } else {
            guard historyInfo.cnt != 0 else { return }
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
        
        guard let wishListInfo = wishListInfo,
              let historyInfo = historyInfo else { return cell }
        
        if indexPath.row == 0 {
            cell.configureData(typeInfo: wishListInfo)
        }
        
        if indexPath.row == 1 {
            cell.configureData(typeInfo: historyInfo)
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
