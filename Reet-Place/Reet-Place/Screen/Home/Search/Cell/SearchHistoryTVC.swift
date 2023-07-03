//
//  SearchHistoryTVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/06/20.
//

import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa
import RxGesture

class SearchHistoryTVC: BaseTableViewCell {
    
    // MARK: - UI components
    
    private let baseStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.alignment = .center
            $0.spacing = 8.0
        }
    private let keywordLabel = BaseAttributedLabel(font: .body1,
                                           text: .empty,
                                           alignment: .left,
                                           color: AssetColors.black)
    private let removeButton = UIButton()
        .then {
            $0.setImage(AssetsImages.cancelContained, for: .normal)
        }
    
    private let separationLineView = UIView()
        .then {
            $0.backgroundColor = AssetColors.gray300
        }
    
    // MARK: - Variables and Properties
    
    var bag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureContentView()
        bindButton()
    }
    
    override func layoutView() {
        super.layoutView()

        configureLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

    // MARK: - Function
    
    func configureSearchHistoryTVC(keywordHistory: String) {
        keywordLabel.text = keywordHistory
    }
    
}

// MARK: - Configure

extension SearchHistoryTVC {
    
    private func configureContentView() {
        selectionStyle = .none
    }
    
}

// MARK: - Layout

extension SearchHistoryTVC {
    
    private func configureLayout() {
        contentView.addSubviews([baseStackView,
                                 separationLineView])
        
        [keywordLabel, removeButton].forEach {
            baseStackView.addArrangedSubview($0)
        }
        
        baseStackView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(contentView)
        }
        
        removeButton.snp.makeConstraints {
            $0.width.height.equalTo(24.0)
        }
        
        separationLineView.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.top.equalTo(baseStackView.snp.bottom)
            $0.horizontalEdges.equalTo(baseStackView)
            $0.bottom.equalTo(contentView)
        }
    }
 
}

// MARK: - Bind

extension SearchHistoryTVC {
    
    private func bindButton() {
        removeButton.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                // TODO: - 키워드 삭제 기능 추가
                print(self.keywordLabel.text, ": 키워드 기록 삭제")
            })
            .disposed(by: bag)
    }
    
}
