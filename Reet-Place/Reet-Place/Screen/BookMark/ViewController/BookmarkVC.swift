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
    
    let allBookmarkBtn = AllBookmarkButton(count: 21)
    
    let emptyBookmarkView = EmptyBookmarkView()
    
    let requestLoginView = RequestLoginView()
    
    override var alias: String {
        "Bookmark"
    }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        bindBtn()
    }
    
    override func bindOutput() {}
    
    // MARK: - Functions
    
}

// MARK: - Configure

extension BookmarkVC {
    
    private func configureContentView() {
        view.addSubviews([allBookmarkBtn,
                          emptyBookmarkView,
                          requestLoginView,
                          bookmarkTypeCV])
        
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
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        emptyBookmarkView.isHidden = false
        requestLoginView.isHidden = false
        
    }
    
}

// MARK: - Input

extension BookmarkVC {
    private func bindBtn() {
        allBookmarkBtn.rx.tap
            .bind(onNext: {
                let bookmarkAllVC = BookmarkAllVC()
                self.navigationController?.pushViewController(bookmarkAllVC, animated: true)
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
        
        if indexPath.row == 0 {
            cell.titleLabel.text = "가고싶어요"
            cell.countLabel.text = "17"
        }
        
        if indexPath.row == 1 {
            cell.titleLabel.text = "다녀왔어요"
            cell.countLabel.text = "4"
        }
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BookmarkVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (UIScreen.main.bounds.width - (20 * 2) - 16) / 2
        let cellHeight = cellWidth / 4 * 5 + 29
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let spacingSize = 16
        
        return CGFloat(spacingSize)
    }
}
