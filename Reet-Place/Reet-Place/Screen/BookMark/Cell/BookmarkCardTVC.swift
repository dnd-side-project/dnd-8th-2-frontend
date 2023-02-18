//
//  BookmarkCardTVC.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/18.
//

import UIKit

import SnapKit
import Then

import RxSwift
import RxGesture
import RxCocoa


class BookmarkCardTVC: BaseTableViewCell {
    
    // MARK: - UI components
    
    // 메인 스택뷰
    let mainStackView = UIStackView()
        .then {
            $0.spacing = 8.0
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .vertical
        }
    
    // 1. 장소 정보 들어가는 View
    let infoView = UIView()
        .then {
            $0.backgroundColor = AssetColors.white
        }
    
    // 1-1. 장소 이름, 카테고리 들어가는 StackView
    let placeNameStackView = UIStackView()
        .then {
            $0.spacing = 8.0
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .horizontal
        }
    
    let placeNameLabel = BaseAttributedLabel(font: .subtitle1,
                                             text: "Place Name",
                                             alignment: .left,
                                             color: AssetColors.black)
    
    let categoryLabel = BaseAttributedLabel(font: .caption,
                                            text: "카테고리",
                                            alignment: .left,
                                            color: AssetColors.gray500)
    
    // 1-2. 별, 주소 들어가는 StackView
    let addressStackView = UIStackView()
        .then {
            $0.spacing = 4.0
            $0.distribution = .fill
            $0.alignment = .center
            $0.axis = .horizontal
        }
    
    let starImageView = UIImageView()
        .then {
            $0.contentMode = .scaleAspectFit
        }
    
    let addressLabel = BaseAttributedLabel(font: .caption,
                                           text: "경상북도 경주시 감포읍 동해안로 1596",
                                           alignment: .center,
                                           color: AssetColors.gray500)
    
    // 1-3. 그룹 구분 아이콘, 더보기 버튼 들어가는 StackView
    let iconStackView = UIStackView()
        .then {
            $0.spacing = 4.0
            $0.distribution = .fill
            $0.alignment = .center
            $0.axis = .horizontal
        }
    let groupIconImageView = UIImageView()
        .then {
            $0.contentMode = .scaleAspectFit
        }
    let moreBtn = UIButton(type: .system)
    
    
    // 2. 등록된 정보, 토글 버튼 들어가는 StackView
    let registeredView = UIView()
    let registeredStackView = UIStackView()
        .then {
            $0.spacing = 4.0
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .horizontal
        }
    let registeredLabel = BaseAttributedLabel(font: .caption,
                                              text: "등록된 정보 (4)",
                                              alignment: .left,
                                              color: AssetColors.primary500)
    let toggleImageView = UIImageView(image: AssetsImages.chevronRight52)
        .then {
            $0.contentMode = .scaleAspectFit
        }
    
    
    // 3. 등록된 정보 토글 했을 때 나오는 StackView
    let toggleStackView = UIStackView()
        .then {
            $0.spacing = 4.0
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .vertical
        }
    let withPeopleView = WithPeopleView()
    
    let border = UIView()
        .then {
            $0.backgroundColor = AssetColors.gray300
        }

    // MARK: - Variables and Properties
    
    var toggleAction: (() -> Void) = {}
    
    var opened: Bool = false
    
    var bag = DisposeBag()
    
    // MARK: - Life Cycle
    override func configureView() {
        super.configureView()
        
        configureContentView()
    }
    
    override func layoutView() {
        super.layoutView()

        configureLayout()
    }

    // MARK: - Function
    
    func configureCell(with cardInfo: BookmarkCardModel) {
        placeNameLabel.text = cardInfo.placeName
        categoryLabel.text = cardInfo.categoryName
        addressLabel.text = cardInfo.address
        registeredLabel.text = "등록된 정보 (\(cardInfo.infoCount))"
        toggleStackView.isHidden = cardInfo.infoHidden
        
        if !cardInfo.withPeople.isEmpty {
            withPeopleView.peopleLabel.text = cardInfo.withPeople
            withPeopleView.isHidden = false
        }
        
    }
}

extension BookmarkCardTVC {
    
    private func configureContentView() {
        contentView.addSubviews([mainStackView, border])
        
        
        mainStackView.addArrangedSubview(infoView)
        
        infoView.addSubviews([placeNameStackView, addressStackView, iconStackView])
        placeNameStackView.addArrangedSubview(placeNameLabel)
        placeNameStackView.addArrangedSubview(categoryLabel)
        
        addressStackView.addArrangedSubview(starImageView)
        addressStackView.addArrangedSubview(addressLabel)
        
        iconStackView.addArrangedSubview(groupIconImageView)
        iconStackView.addArrangedSubview(moreBtn)
        
        
        mainStackView.addArrangedSubview(registeredView)
        registeredView.addSubview(registeredStackView)
        
        registeredStackView.addArrangedSubview(registeredLabel)
        registeredStackView.addArrangedSubview(toggleImageView)
        
        mainStackView.addArrangedSubview(toggleStackView)
        toggleStackView.addArrangedSubview(withPeopleView)
        withPeopleView.isHidden = true
        
        registeredStackView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.toggleAction()
            })
            .disposed(by: bag)
    }
    
}

extension BookmarkCardTVC {
    
    private func configureLayout() {
        border.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        mainStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-16)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        infoView.snp.makeConstraints {
            $0.height.equalTo(42)
        }
        
        placeNameStackView.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.top)
            $0.leading.equalTo(infoView.snp.leading)
            $0.height.equalTo(24)
        }
        addressStackView.snp.makeConstraints {
            $0.bottom.equalTo(infoView.snp.bottom)
            $0.leading.equalTo(infoView.snp.leading)
            $0.height.equalTo(14)
        }
        iconStackView.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.top)
            $0.trailing.equalTo(infoView.snp.trailing)
            $0.height.equalTo(24)
        }
        
        registeredView.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        
        registeredStackView.snp.makeConstraints {
            $0.top.equalTo(registeredView.snp.top)
            $0.leading.equalTo(registeredView.snp.leading)
            $0.bottom.equalTo(registeredView.snp.bottom)
        }
        toggleImageView.snp.makeConstraints {
            $0.width.equalTo(toggleImageView.snp.height)
        }
        
        withPeopleView.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        

    }
 
}
