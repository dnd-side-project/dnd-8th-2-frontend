//
//  ReetPopUpView.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/04/20.
//

import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa
import RxGesture


class ReetPopUp: BaseViewController {
    
    // MARK: - UI components
    
    let dimmedView = UIView()
        .then {
            $0.backgroundColor = AssetColors.gray900.withAlphaComponent(0.7)
        }
    
    let popView = UIView()
        .then {
            $0.layer.cornerRadius = 5.0
            $0.backgroundColor = .white
        }
    
    let iconImageView = UIImageView(image: AssetsImages.map20)
    
    let mentStackView = UIStackView()
        .then {
            $0.spacing = 12.0
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .vertical
        }
    
    let popViewTitle = BaseAttributedLabel(font: .h4,
                                          text: "북마크를 해제할까요?",
                                          alignment: .center,
                                          color: AssetColors.black)
    
    let popViewDesc = BaseAttributedLabel(font: .body2,
                                          text: "북마크를 해제하시면,\n입력하셨던 내용이 전부 사라집니다.",
                                          alignment: .center,
                                          color: AssetColors.error)
        .then {
            $0.numberOfLines = .zero
        }
    
    let btnStackView = UIStackView()
        .then {
            $0.spacing = 8.0
            $0.distribution = .fillEqually
            $0.alignment = .fill
            $0.axis = .horizontal
        }
    
    let cancelBtn = ReetButton(with: "취소",
                               for: ReetButtonStyle.outlined)
    
    let confirmBtn = ReetButton(with: "해제",
                                for: ReetButtonStyle.secondary)
    
    
    // MARK: - Variables and Properties
    
    let popViewWidth = UIScreen.main.bounds.width - 40.0
    
    
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
    
    override func bindInput() {
        super.bindInput()
        
        bindTap()
    }
    
    
    // MARK: - Functions
    
    
    
}


// MARK: - Configure

extension ReetPopUp {
    
    private func configureContentView() {
        view.backgroundColor = UIColor.clear
        
        [dimmedView, popView, iconImageView, mentStackView, btnStackView].forEach {
            view.addSubview($0)
        }
        
        [popViewTitle, popViewDesc].forEach {
            mentStackView.addArrangedSubview($0)
        }
        
        [cancelBtn, confirmBtn].forEach {
            btnStackView.addArrangedSubview($0)
        }
    }
    
}


// MARK: - Layout

extension ReetPopUp {
    
    private func configureLayout() {
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        popView.snp.makeConstraints {
            $0.width.equalTo(popViewWidth)
            $0.height.equalTo(257)
            $0.center.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints {
            $0.height.width.equalTo(24)
            $0.top.equalTo(popView).offset(33)
            $0.centerX.equalTo(popView)
        }
        
        popViewTitle.snp.makeConstraints {
            $0.height.equalTo(28)
        }
        
        mentStackView.snp.makeConstraints {
            $0.height.equalTo(90)
            $0.top.equalTo(popView).offset(72)
            $0.leading.trailing.equalTo(popView).inset(24)
        }
        
        btnStackView.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.bottom.equalTo(popView).offset(-20)
            $0.leading.trailing.equalTo(popView).inset(16)
        }
        
    }
    
}


// MARK: - Input

extension ReetPopUp {
    
    private func bindTap() {
        dimmedView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.dismiss(animated: false)
            })
            .disposed(by: bag)
        
        cancelBtn.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.dismiss(animated: false)
            })
            .disposed(by: bag)
        
        confirmBtn.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.dismiss(animated: false)
            })
            .disposed(by: bag)
    }
    
}
