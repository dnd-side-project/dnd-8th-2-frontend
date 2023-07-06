//
//  SearchVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/06/08.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

import Then
import SnapKit

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
                          searchResultEmptyStackView, searchResultTableView])
        
        [backButton, searchTextField].forEach {
            searchBarStackView.addArrangedSubview($0)
        }
        
        [recentKeywordLabel, removeAllKeywordButton].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        [searchResultEmptyImageView, searchResultEmptyTitleLabel, searchResultEmptySubTitleLabel, searchResultEmptyContentLabel].forEach {
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
            $0.top.horizontalEdges.equalTo(titleStackView)
        }
        searchResultEmptyImageView.snp.makeConstraints {
            $0.width.height.equalTo(160.0)
        }
        searchResultTableView.snp.makeConstraints {
            $0.top.equalTo(titleStackView)
            $0.horizontalEdges.bottom.equalTo(view)
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
                print(self.searchTextField.text, " TODO: - Search Place API to be call")
                
                self.isShowSearchResultUI(show: true)
            })
            .disposed(by: bag)
        
        cancelButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.searchTextField.text = .empty
                self.cancelButton.isHidden = true
                self.isShowSearchResultUI(show: false)
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
        
        viewModel.output.searchHistoryListDataSource
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
            cell.configureSearchResultTVC(placeInformation: searchResult, bookmarkCardActionDelegate: self, index: indexPath.row)
            
            return cell
        }
        
        viewModel.output.searchResultDataSource
            .bind(to: searchResultTableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        viewModel.output.searchResultList
            .subscribe(onNext: { [weak self] items in
                guard let self = self else { return }
                
                if items.count == 0 {
                    self.view.bringSubviewToFront(self.searchResultEmptyStackView)
                }
            })
            .disposed(by: bag)
    }
    
}

// MARK: - BookmarkCardAction Delegate

extension SearchVC: BookmarkCardAction {
    
    func infoToggle(index: Int) {
        var card = viewModel.output.searchResultList.value
        card[index].infoHidden = !card[index].infoHidden
        viewModel.output.searchResultList.accept(card)
        searchResultTableView.reloadData()
    }
    
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
    
    private func actionDefaultPlaceInfoCell(index: Int, row: Int) {
        switch row {
        case 0:
            // TODO: - 검색결과 북마크 추가 기능
            print("북마크(추가) 메뉴 선택")
        case 1:
            // TODO: - 장소공유 기능
            print("공유하기 메뉴 선택")
        default:
            break
        }
    }
    
    private func actionBookmarkCell(index: Int, row: Int) {
        switch row {
        case 0:
            showBottomSheet(index: index)
        case 1:
            print("TODO: - Copy Link to be call")
        case 2:
            print("TODO: - Delete Bookmark API to be call")
        default:
            break
        }
    }
    
    private func showBottomSheet(index: Int) {
        let bottomSheetVC = BookmarkBottomSheetVC()
        let cardInfo = viewModel.output.searchResultList.value[index]
        bottomSheetVC.configureSheetData(with: cardInfo)

        bottomSheetVC.modalPresentationStyle = .overFullScreen
        present(bottomSheetVC, animated: false)
    }
    
}
