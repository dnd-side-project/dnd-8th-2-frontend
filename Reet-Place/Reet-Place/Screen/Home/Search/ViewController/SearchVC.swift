//
//  SearchVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/06/08.
//

import SafariServices
import UIKit
import CoreLocation

import RxSwift
import RxCocoa
import RxDataSources

import Then
import SnapKit

/// 장소 검색과 관련된 함수를 정의
protocol SearchPlaceAction {
    func getCurrentLocationCoordinate() -> CLLocationCoordinate2D?
}

class SearchVC: BaseViewController {
    
    // MARK: - UI components
    
    private let searchBarStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillProportionally
            $0.spacing = .zero
        }
    private let backButton = UIButton()
        .then {
            $0.setImage(AssetsImages.chevronLeft48, for: .normal)
        }
    
    private let searchTextField = UITextField()
        .then {
            $0.backgroundColor = .white
            $0.font = AssetFonts.body1.font
            $0.attributedPlaceholder = NSAttributedString(
                string: "SearchPlaceKeyword".localized,
                attributes: [NSAttributedString.Key.foregroundColor: AssetColors.gray400]
            )
            $0.addLeftPadding(padding: 12)
            $0.rightViewMode = .whileEditing
            
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = AssetColors.gray300.cgColor
            $0.layer.borderWidth = 1.0
        }
    private let cancelButton = UIButton()
        .then {
            $0.setImage(AssetsImages.cancelContained, for: .normal)
            $0.isHidden = true
        }
    private let searchButton = UIButton()
        .then {
            $0.setImage(AssetsImages.search, for: .normal)
            $0.isEnabled = false
        }
    
    private let titleStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillProportionally
            $0.spacing = .zero
        }
    private let recentKeywordLabel = UILabel()
        .then {
            $0.text = "RecentKeywords".localized
            $0.font = AssetFonts.h4.font
            $0.textColor = AssetColors.black
        }
    private let removeAllKeywordButton = ReetTextButton(with: "RemoveAllKeywords".localized, for: .tertiary)
        .then {
            $0.isEnabled = false
        }
    
    private let historyCategoryTabBarView = ReetMenuTabBarView()
        .then {
            $0.configureMenuBarCollectionView(customSectionInset: UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0))
        }
    
    private let searchHistoryListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        .then {
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.register(SearchHistoryListCVC.self, forCellWithReuseIdentifier: SearchHistoryListCVC.className)
        }
    
    private let searchResultTableView = UITableView(frame: .zero, style: .plain)
        .then {
            $0.rowHeight = UITableView.automaticDimension
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.register(SearchResultTVC.self, forCellReuseIdentifier: SearchResultTVC.className)
            
            $0.isHidden = true
        }
    private let goToTopButton = ReetFAB(size: .round(.small), title: nil, image: .goToTop)
    
    private let searchResultEmptyStackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .center
            $0.spacing = 24.0
            
            $0.isHidden = true
        }
    private let searchResultEmptyImageView = UIImageView()
        .then {
            $0.image = AssetsImages.noSearchResult
            $0.contentMode = .scaleAspectFit
        }
    private let searchResultEmptyTitleLabel = BaseAttributedLabel(font: AssetFonts.h4,
                                                      text: "SearchResultEmptyTitle".localized,
                                                      alignment: .center,
                                                      color: AssetColors.black)
    private let searchResultEmptySubTitleLabel = BaseAttributedLabel(font: AssetFonts.subtitle2,
                                                      text: "SearchResultEmptySubTitle".localized,
                                                      alignment: .center,
                                                      color: AssetColors.gray500)
    private let searchResultEmptyContentLabel = BaseAttributedLabel(font: AssetFonts.body2,
                                                        text: "SearchResultEmptyContent".localized,
                                                        alignment: .center,
                                                        color: AssetColors.gray500)
        .then {
            $0.setLineBreakMode()
        }
        
    // MARK: - Variables and Properties
    
    private let viewModel = SearchVM()
    
    var delegateSearchPlaceAction: SearchPlaceAction?
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        historyCategoryTabBarView.setTabPosition(indexPath: IndexPath(item: 0, section: 0))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureSearchHistoryListCollectionView()
    }
    
    override func configureView() {
        super.configureView()
        
        configureSearchTextField()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    override func bindInput() {
        super.bindInput()
        
        bindButton()
        bindTextField()
        bindInputHistoryCategoryTabBarView()
        bindKeywordHistoryListCollectionScrollView()
    }
    
    override func bindOutput() {
        super.bindOutput()
        
        bindOutputHistoryCategoryTabBarView()
        bindSearchHistroyListCollectionView()
        bindSearchResultTableView()
    }
    
    // MARK: - Functions
    
    private func isShowSearchResultUI(show: Bool) {
        searchResultEmptyStackView.isHidden = show ? false : true
        searchResultTableView.isHidden = show ? false : true
    }
    
    private func requestSearchPlaceKeyword(requestPage: Int) {
        if let curLocationCoordinate = delegateSearchPlaceAction?.getCurrentLocationCoordinate() {
            if let keyword = searchTextField.text {
                viewModel.requestSearchPlaceKeyword(placeKeyword: SearchPlaceKeywordRequestModel(lat: curLocationCoordinate.latitude,
                                                                                                 lng: curLocationCoordinate.longitude,
                                                                                                 placeKeword: keyword,
                                                                                                 page: requestPage))
            } else {
                self.showErrorAlert("SearchResultEmptyContent".localized)
            }
        } else {
            self.showErrorAlert("FailGetCurLocationCoordinate".localized)
        }
    }
    
}

// MARK: - Configure

extension SearchVC {
    
    private func configureSearchTextField() {
        let rightPaddingView = UIView()
        rightPaddingView.snp.makeConstraints {
            $0.width.equalTo(16.0 + 28.0 + 10.0 + 20.0)
        }
        
        searchTextField.rightView = rightPaddingView
        searchTextField.rightViewMode = .always
    }
    
    private func configureSearchHistoryListCollectionView() {
        let layout = UICollectionViewFlowLayout()
            .then {
                $0.scrollDirection = .horizontal
                $0.minimumLineSpacing = 0.0
                $0.minimumInteritemSpacing = 0.0
                $0.itemSize = CGSize(width: searchHistoryListCollectionView.frame.size.width, height: searchHistoryListCollectionView.frame.size.height)
            }
        searchHistoryListCollectionView.collectionViewLayout = layout
    }
    
}

// MARK: - Layout

extension SearchVC {
    
    private func configureLayout() {
        // Add Subviews
        view.addSubviews([searchBarStackView, cancelButton, searchButton,
                          titleStackView,
                          historyCategoryTabBarView,
                          searchHistoryListCollectionView,
                          searchResultEmptyStackView, searchResultTableView, goToTopButton])
        
        [backButton, searchTextField].forEach {
            searchBarStackView.addArrangedSubview($0)
        }
        
        [recentKeywordLabel, removeAllKeywordButton].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        [searchResultEmptyImageView,
         searchResultEmptyTitleLabel,
         searchResultEmptySubTitleLabel,
         searchResultEmptyContentLabel].forEach {
            searchResultEmptyStackView.addArrangedSubview($0)
        }
        searchResultEmptyStackView.setCustomSpacing(12.0, after: searchResultEmptyTitleLabel)
        searchResultEmptyStackView.setCustomSpacing(4.0, after: searchResultEmptySubTitleLabel)
        
        // Make Constraints
        searchBarStackView.snp.makeConstraints {
            $0.height.equalTo(44.0)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12.0)
            $0.horizontalEdges.equalTo(view).inset(20.0)
        }
        backButton.snp.makeConstraints {
            $0.width.equalTo(backButton.snp.height)
        }
        
        cancelButton.snp.makeConstraints {
            $0.width.height.equalTo(24.0)
            
            $0.centerY.equalTo(searchTextField)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-10.0)
        }
        searchButton.snp.makeConstraints {
            $0.width.height.equalTo(28.0)
            
            $0.centerY.equalTo(searchTextField)
            $0.trailing.equalTo(searchTextField.snp.trailing).inset(12.0)
        }
        
        titleStackView.snp.makeConstraints {
            $0.height.equalTo(48.0)
            
            $0.top.equalTo(searchBarStackView.snp.bottom).offset(24.0)
            $0.horizontalEdges.equalTo(searchBarStackView)
        }
        removeAllKeywordButton.snp.makeConstraints {
            $0.width.equalTo(93.0)
        }
        
        historyCategoryTabBarView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalTo(view)
        }
        
        searchHistoryListCollectionView.snp.makeConstraints {
            $0.top.equalTo(historyCategoryTabBarView.snp.bottom).offset(16.0)
            $0.horizontalEdges.bottom.equalTo(view)
        }
        
        searchResultEmptyStackView.snp.makeConstraints {
            $0.top.equalTo(titleStackView).offset(40.0)
            $0.horizontalEdges.equalTo(titleStackView)
        }
        searchResultEmptyImageView.snp.makeConstraints {
            $0.width.height.equalTo(160.0)
        }
        
        searchResultTableView.snp.makeConstraints {
            $0.top.equalTo(titleStackView)
            $0.horizontalEdges.bottom.equalTo(view)
        }
        goToTopButton.snp.makeConstraints {
            $0.trailing.equalTo(searchResultTableView).inset(24.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(24.0)
        }
    }
    
}

// MARK: - Input

extension SearchVC {
    
    private func bindButton() {
        backButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.popVC()
            })
            .disposed(by: bag)
        
        searchButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.searchResultTableView.scrollToTop()
                self.requestSearchPlaceKeyword(requestPage: 1)
                self.isShowSearchResultUI(show: true)
            })
            .disposed(by: bag)
        
        cancelButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.searchTextField.text = .empty
                self.cancelButton.isHidden = true
                self.searchButton.isEnabled = false
                self.goToTopButton.isHidden = true
                
                self.isShowSearchResultUI(show: false)
            })
            .disposed(by: bag)
        
        goToTopButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.searchResultTableView.scrollToTop()
            })
            .disposed(by: bag)
    }
    
    private func bindTextField() {
        searchTextField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.searchTextField.layer.borderColor = AssetColors.primary500.cgColor
            })
            .disposed(by: bag)
        
        searchTextField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.searchTextField.layer.borderColor = AssetColors.gray300.cgColor
            })
            .disposed(by: bag)
        
        searchTextField.rx.text
            .changed
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .empty)
            .drive(onNext: { [weak self] text in
                guard let self = self,
                let changedText = text else { return }
                
                self.cancelButton.isHidden = changedText.count > 0 ? false : true
                self.searchButton.isEnabled = changedText.count > 0
                self.isShowSearchResultUI(show: changedText.count > 0)
            })
            .disposed(by: bag)
    }
    
    private func bindInputHistoryCategoryTabBarView() {
        historyCategoryTabBarView.menuBarCollectionView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                
                self.historyCategoryTabBarView.menuBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                
                let offset = CGFloat(indexPath.row) * self.searchHistoryListCollectionView.frame.width
                self.searchHistoryListCollectionView.scrollToHorizontalOffset(offset: offset)
            })
            .disposed(by: bag)
    }
    
    private func bindKeywordHistoryListCollectionScrollView() {
        searchHistoryListCollectionView.rx.willEndDragging
            .asDriver()
            .drive(onNext: { [weak self] velocity, targetContentOffset in
                guard let self = self else { return }
                
                let menuIndex = Int(targetContentOffset.pointee.x / self.searchHistoryListCollectionView.frame.width)
                let indexPath = IndexPath(item: menuIndex, section: 0)
                self.historyCategoryTabBarView.menuBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            })
            .disposed(by: bag)
    }
    
}

// MARK: - Output

extension SearchVC {
    
    private func bindOutputHistoryCategoryTabBarView() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<TabPlaceCategoryListDataSource> { _,
            collectionView,
            indexPath,
            tabCategoryType in
            
            guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: ReetMenuTarBarCVC.className,
                                     for: indexPath) as? ReetMenuTarBarCVC else {
                fatalError("Cannot deqeue cells named ReetMenuTarBarCVC")
            }
            cell.configureReetMenuTarBarCVC(tabPlaceCategory: tabCategoryType)
            
            return cell
        }
        
        viewModel.output.tabPlaceCategoryDataSources
            .bind(to: historyCategoryTabBarView.menuBarCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    private func bindSearchHistroyListCollectionView() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SearchHistoryListDataSource> { _,
            collectionView,
            indexPath,
            categoryType in
            
            guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: SearchHistoryListCVC.className,
                                     for: indexPath) as? SearchHistoryListCVC else {
                fatalError("Cannot deqeue cells named SearchHistoryListCVC")
            }
            cell.configureSearchHistoryListCVC(categoryType: categoryType, viewModel: self.viewModel)
            
            return cell
        }
        
        viewModel.output.searchHistory.dataSource
            .bind(to: searchHistoryListCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    private func bindSearchResultTableView() {
        let dataSource = RxTableViewSectionedReloadDataSource<SearchResultDataSource> { _,
            tableView,
            indexPath,
            searchResult in
            
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: SearchResultTVC.className,
                                     for: indexPath) as? SearchResultTVC else {
                fatalError("Cannot deqeue cells named SearchResultTVC")
            }
            cell.configureSearchResultTVC(placeInformation: searchResult, delegateBookmarkCardAction: self, cellIndex: indexPath.row)
            
            return cell
        }
        
        viewModel.output.searchResult.dataSource
            .bind(to: searchResultTableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        viewModel.output.searchResult.list
            .withUnretained(self)
            .subscribe(onNext: { owner, items in
                if items.count == 0 {
                    owner.view.bringSubviewToFront(owner.searchResultEmptyStackView)
                    owner.goToTopButton.isHidden = true
                } else {
                    owner.view.sendSubviewToBack(owner.searchResultEmptyStackView)
                    owner.goToTopButton.isHidden = false
                    owner.searchResultTableView.reloadData()
                }
            })
            .disposed(by: bag)
        
        searchResultTableView.rx.didScroll
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                let offsetY = self.searchResultTableView.contentOffset.y
                let contentHeight = self.searchResultTableView.contentSize.height
                let height = self.searchResultTableView.frame.height
                
                if offsetY > (contentHeight - height) {
                    if self.viewModel.output.searchResult.isPaging.value == false &&
                        self.viewModel.output.searchResult.lastPage.value == false {
                        self.requestSearchPlaceKeyword(requestPage: self.viewModel.output.searchResult.page + 1)
                    }
                }
            })
            .disposed(by: bag)
    }
    
}

// MARK: - BookmarkCardAction Delegate

extension SearchVC: BookmarkCardAction {
    
    func infoToggle(index: Int) {}
    
    func showMenu(index: Int, location: CGRect, selectMenuType: SelectBoxStyle) {
        showSelectBox(targetVC: self, location: location, style: selectMenuType) { [weak self] row in
            guard let self = self else { return }
            
            switch selectMenuType {
            case .defaultPlaceInfo:
                self.actionDefaultPlaceInfoCell(index: index, row: row)
            case .bookmarked:
                self.actionBookmarkCell(index: index, row: row)
            }
        }
    }
    
    func openRelatedURL(_ urlString: String?) {
        guard let urlString, let url = URL(string: urlString) else { return }
        let safariVC = SFSafariViewController(url: url)
        
        safariVC.preferredBarTintColor = AssetColors.white
        safariVC.preferredControlTintColor = AssetColors.primary500
        
        navigationController?.pushViewController(safariVC, animated: true)
    }
    
    private func actionDefaultPlaceInfoCell(index: Int, row: Int) {
        let searchPlaceInfo = viewModel.output.searchResult.list.value[index]
        switch row {
        case 0:
            let bottomSheetVC = BookmarkBottomSheetVC(isBookmarking: false)
            bottomSheetVC.configureInitialData(with: searchPlaceInfo.toSearchPlaceListContent())
            
            bottomSheetVC.savedBookmarkType
                .withUnretained(self)
                .subscribe { owner, _ in
                    // TODO: - 저장 완료 후 검색 결과 리스트 업데이트 방식 논의 필요
                    owner.showToast(message: "BookmarkSaved".localized)
                }
                .disposed(by: bag)
            
            bottomSheetVC.modalPresentationStyle = .overFullScreen
            present(bottomSheetVC, animated: true)
        case 1:
            UIPasteboard.general.string = searchPlaceInfo.url
            showToast(message: "LinkCopied".localized)
        default:
            break
        }
    }
    
    private func actionBookmarkCell(index: Int, row: Int) {
        let searchPlaceInfo = viewModel.output.searchResult.list.value[index]
        switch row {
        case 0:
            showBottomSheet(index: index)
        case 1:
            UIPasteboard.general.string = searchPlaceInfo.url
            showToast(message: "LinkCopied".localized)
        case 2:
            print("TODO: - Delete Bookmark API to be call")
        default:
            break
        }
    }
    
    private func showBottomSheet(index: Int) {
        let bottomSheetVC = BookmarkBottomSheetVC(isBookmarking: false)
        // TODO: - 북마크 바텀 카드 정보 값 대응
        let cardInfo = viewModel.output.searchResult.list.value[index]
        print("장소 정보 호출: ", cardInfo)
//        bottomSheetVC.configureSheetData(with: cardInfo)

        bottomSheetVC.modalPresentationStyle = .overFullScreen
        present(bottomSheetVC, animated: false)
    }
    
}
