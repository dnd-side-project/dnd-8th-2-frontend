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
    
    private var delegateSearchHistoryListAction: SearchHistoryListAction?
    
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
    func configureSearchHistoryListCVC(viewModel: SearchVM,
                                       delegateSearchHistoryListAction: SearchHistoryListAction,
                                       delegateSearchHistoryAction delegate: SearchHistoryAction) {
        self.delegateSearchHistoryListAction = delegateSearchHistoryListAction
        
        bindSearchHistroyTableView(viewModel: viewModel, 
                                   delegateSearchHistoryAction: delegate)
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
    
    private func bindSearchHistroyTableView(viewModel: SearchVM, 
                                            delegateSearchHistoryAction delegate: SearchHistoryAction) {
        let dataSource = RxTableViewSectionedReloadDataSource<KeywordHistoryDataSource> { _,
            tableView,
            indexPath,
            searchHistoryContent in

            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: SearchHistoryTVC.className,
                                     for: indexPath) as? SearchHistoryTVC else {
                fatalError("Cannot deqeue cells named SearchHistoryTVC")
            }
            cell.configureSearchHistoryTVC(searchHistoryContent: searchHistoryContent,
                                           delegateSearchHistoryAction: delegate)

            return cell
        }
        
        var keywordHistoryDataSource: Observable<Array<KeywordHistoryDataSource>> {
            viewModel.output.searchHistory.keywordList.map { [KeywordHistoryDataSource(items: $0)] }
        }
        
        keywordHistoryDataSource
            .bind(to: searchHistoryTableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        viewModel.output.searchHistory.isUpdated
            .withUnretained(self)
            .subscribe(onNext: { owner, isUpdated in
                if isUpdated {
                    owner.searchHistoryTableView.scrollToTop()
                    viewModel.updateKeywordHistory()
                    owner.searchHistoryTableView.reloadData()
                }
            })
            .disposed(by: bag)
        
        viewModel.output.searchHistory.keywordList
            .withUnretained(self)
            .subscribe(onNext: { owner, list in
                owner.searchHistoryTableView.isHidden = list.count == 0
            })
            .disposed(by: bag)
        
        searchHistoryTableView.rx.modelSelected(SearchHistoryContent.self)
            .withUnretained(self)
            .bind(onNext: { owner, searchHistoryContent in
                owner.delegateSearchHistoryListAction?.didTapKeyword(searchHistoryContent: searchHistoryContent)
                viewModel.output.searchHistory.isNeedUpdated.accept(true)
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
