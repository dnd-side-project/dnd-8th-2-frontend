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
    
    private let searchHistoryTableView = UITableView(frame: .zero, style: .plain)
        .then {
            $0.rowHeight = 48.0
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
    func configureSearchHistoryListCVC(categoryType: TabPlaceCategoryList, viewModel: SearchVM) {
        bindSearchHistroyTableView(categoryType: categoryType, viewModel: viewModel)
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
            $0.horizontalEdges.equalTo(contentView).inset(20.0)
        }
    }
    
}

extension SearchHistoryListCVC {
    
    private func bindSearchHistroyTableView(categoryType: TabPlaceCategoryList, viewModel: SearchVM) {
        let dataSource = RxTableViewSectionedReloadDataSource<KeywordHistoryDataSource> { _,
            tableView,
            indexPath,
            keyword in

            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: SearchHistoryTVC.className,
                                     for: indexPath) as? SearchHistoryTVC else {
                fatalError("Cannot deqeue cells named SearchHistoryTVC")
            }
            cell.configureSearchHistoryTVC(keywordHistory: keyword.description)

            return cell
        }
        
        let keywordHistoryList: BehaviorRelay<Array<String>> = BehaviorRelay(value: categoryType.list)
        var keywordHistoryDataSource: Observable<Array<KeywordHistoryDataSource>> {
            keywordHistoryList.map { [KeywordHistoryDataSource(items: $0)] }
        }
        
        keywordHistoryDataSource
            .bind(to: searchHistoryTableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        keywordHistoryList
            .subscribe(onNext: { [weak self] items in
                guard let self = self else { return }

                self.searchHistoryTableView.isHidden = items.count == 0 ? true : false
            })
            .disposed(by: bag)
    }
    
}
