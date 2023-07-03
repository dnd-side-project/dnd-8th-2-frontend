//
//  SearchResultTVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/06/21.
//

import UIKit

import SnapKit
import Then

import RxSwift
import RxGesture
import RxCocoa

class SearchResultTVC: BaseTableViewCell {
    
    // MARK: - UI components
    
    private let placeInformationView = PlaceInfoView()
    
    // MARK: - Variables and Properties
    
    var bag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureTVC()
    }
    
    override func layoutView() {
        super.layoutView()

        configureLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        placeInformationView.prepareForReuseCell()
    }

    // MARK: - Function
    
    /// 검색결과 장소 셀의 데이터 정보를 입력하는 함수
    func configureSearchResultTVC(placeInformation: BookmarkCardModel, bookmarkCardActionDelegate: BookmarkCardAction, index: Int) {
        placeInformationView.configurePlaceInfoView(cardInfo: placeInformation, delegate: bookmarkCardActionDelegate, cellIndex: index)
    }
    
}

// MARK: - Configure

extension SearchResultTVC {
    
    private func configureTVC() {
        selectionStyle = .none
    }
    
}

// MARK: - Layout

extension SearchResultTVC {
    
    private func configureLayout() {
        contentView.addSubviews([placeInformationView])
        
        placeInformationView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }
 
}
