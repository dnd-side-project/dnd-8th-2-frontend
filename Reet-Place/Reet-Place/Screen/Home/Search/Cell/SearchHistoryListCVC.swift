//
//  SearchHistoryListCVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/06/22.
//

import UIKit

import Then
import SnapKit

import RxCocoa
import RxSwift
import RxDataSources

class SearchHistoryListCVC : BaseCollectionViewCell {
    
    // MARK: - UI components
    
    let searchHistoryTableView = UITableView(frame: .zero, style: .plain)
        .then {
            $0.rowHeight = 48.0
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.register(SearchHistoryTVC.self, forCellReuseIdentifier: SearchHistoryTVC.className)
        }
    private let searchHistoryEmptyStackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .center
            $0.spacing = 24.0
        }
    private let searchHistoryEmptyImageView = UIImageView()
        .then {
            $0.image = AssetsImages.noData160
            $0.contentMode = .scaleAspectFit
        }
    private let searchHistoryEmptyTitleLabel = BaseAttributedLabel(font: AssetFonts.h4,
                                                      text: "SearchHistoryEmptyTitle".localized,
                                                      alignment: .center,
                                                      color: AssetColors.black)
    private let searchHistoryEmptyContentLabel = BaseAttributedLabel(font: AssetFonts.body2,
                                                        text: "SearchHistoryEmptyContent".localized,
                                                        alignment: .center,
                                                        color: AssetColors.gray500)
        .then {
            $0.setLineBreakMode()
        }
    
    // MARK: - Variables and Properties
    
    var bag = DisposeBag()
    
    var delegateSearchHistoryListAction: SearchHistoryListAction?
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bag = DisposeBag()
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Functions
}

// MARK: - Configure

extension SearchHistoryListCVC {
    
    /// 검색기록 테이블 뷰 내용을 설정하는 함수
    func configureSearchHistoryListCVC(categoryType: TabPlaceCategoryList,
                                       delegateSearchHistoryListAction: SearchHistoryListAction,
                                       delegateSearchHistoryAction delegate: SearchHistoryAction) {
        self.delegateSearchHistoryListAction = delegateSearchHistoryListAction
        
        bindSearchHistroyTableView(categoryType: categoryType, delegateSearchHistoryAction: delegate)
    }
    
}

// MARK: - Layout

extension SearchHistoryListCVC {
    
    private func configureLayout() {
        // Add Subviews
        contentView.addSubviews([searchHistoryEmptyStackView, searchHistoryTableView])
        
        [searchHistoryEmptyImageView, searchHistoryEmptyTitleLabel, searchHistoryEmptyContentLabel].forEach {
            searchHistoryEmptyStackView.addArrangedSubview($0)
        }
        searchHistoryEmptyStackView.setCustomSpacing(12.0, after: searchHistoryEmptyTitleLabel)
        
        // Make Constraints
        searchHistoryEmptyStackView.snp.makeConstraints {
            $0.top.equalTo(searchHistoryTableView).offset(40.0)
            $0.centerX.equalTo(searchHistoryTableView)
        }
        searchHistoryEmptyImageView.snp.makeConstraints {
            $0.width.height.equalTo(160.0)
        }
        searchHistoryTableView.snp.makeConstraints {
            $0.verticalEdges.equalTo(contentView)
            $0.horizontalEdges.equalTo(contentView)
        }
    }
    
}

extension SearchHistoryListCVC {
    
    private func bindSearchHistroyTableView(categoryType: TabPlaceCategoryList, delegateSearchHistoryAction delegate: SearchHistoryAction) {
        let dataSource = RxTableViewSectionedReloadDataSource<KeywordHistoryDataSource> { _,
            tableView,
            indexPath,
            keyword in

            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: SearchHistoryTVC.className,
                                     for: indexPath) as? SearchHistoryTVC else {
                fatalError("Cannot deqeue cells named SearchHistoryTVC")
            }
            cell.configureSearchHistoryTVC(keywordHistory: keyword.description, delegateSearchHistoryAction: delegate)

            return cell
        }
        
        let keywordHistoryList: BehaviorRelay<Array<String>> = BehaviorRelay(value: CoreDataManager.shared.getKeywordHistoryList())
        var keywordHistoryDataSource: Observable<Array<KeywordHistoryDataSource>> {
            keywordHistoryList.map { [KeywordHistoryDataSource(items: $0)] }
        }
        
        keywordHistoryDataSource
            .bind(to: searchHistoryTableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        keywordHistoryList
            .withUnretained(self)
            .subscribe(onNext: { owner, items in
                owner.searchHistoryTableView.isHidden = items.count == 0 ? true : false
            })
            .disposed(by: bag)
        
        searchHistoryTableView.rx.modelSelected(String.self)
            .withUnretained(self)
            .bind(onNext: { owner, keyword in
                owner.delegateSearchHistoryListAction?.didTapKeyword(keyword: keyword)
            })
            .disposed(by: bag)
        
        searchHistoryTableView.rx.willBeginDragging
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.findViewController()?.view.endEditing(true)
            })
            .disposed(by: bag)
    }
    
}
