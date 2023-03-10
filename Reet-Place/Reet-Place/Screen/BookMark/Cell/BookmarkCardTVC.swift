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


protocol BookmarkCardAction {
    func infoToggle(index: Int)
    func showMenu(index: Int)
}

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
            $0.spacing = 8.0
            $0.distribution = .fill
            $0.alignment = .center
            $0.axis = .horizontal
        }
    
    let starImageView = UIImageView()
        .then {
            $0.contentMode = .scaleAspectFit
        }
    
    let addressBorder = UIView()
        .then {
            $0.backgroundColor = AssetColors.gray300
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
    
    let cardMenuBtn = UIButton(type: .system)
        .then {
            $0.setImage(AssetsImages.cardMenu24, for: .normal)
        }
    
    
    // 2. 등록된 정보, 토글 버튼 들어가는 StackView
    let registeredView = UIView()
    
    let registeredStackView = UIStackView()
        .then {
            $0.spacing = 4.0
            $0.distribution = .fill
            $0.alignment = .center
            $0.axis = .horizontal
        }
    
    let registeredLabel = BaseAttributedLabel(font: .caption,
                                              text: nil,
                                              alignment: .left,
                                              color: AssetColors.primary500)
    
    let expandMoreImageView = UIImageView(image: AssetsImages.expandMore16)
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
    let firstUrlView = RelatedUrlButton()
    let secondUrlView = RelatedUrlButton()
    let thirdUrlView = RelatedUrlButton()
    
    
    // 4. cell border
    let contentBorder = UIView()
        .then {
            $0.backgroundColor = AssetColors.gray300
        }

    
    // MARK: - Variables and Properties
    
    var delegate: BookmarkCardAction?
    
    var index: Int?
    
    var urlView: [RelatedUrlButton] = []
    
    var bag = DisposeBag()
    
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureContentView()
        bindToggle()
        bindMenuBtn()
    }
    
    override func layoutView() {
        super.layoutView()

        configureLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        registeredStackView.isUserInteractionEnabled = true
        
        withPeopleView.peopleLabel.text = nil
        withPeopleView.isHidden = true
        
        urlView.forEach {
            $0.urlLabel.text = nil
            $0.isHidden = true
        }
    }

    // MARK: - Function
    
    func configureCell(with cardInfo: BookmarkCardModel) {
        placeNameLabel.text = cardInfo.placeName
        categoryLabel.text = cardInfo.categoryName
        addressLabel.text = cardInfo.address
        
        switch cardInfo.starCount {
        case 3:
            starImageView.image = AssetsImages.cardThreeStar14
        case 2:
            starImageView.image = AssetsImages.cardTwoStar14
        default:
            starImageView.image = AssetsImages.cardThreeStar14
        }
        
        if cardInfo.groupType == "가고싶어요" {
            groupIconImageView.image = AssetsImages.cardWishChip20
        }
        if cardInfo.groupType == "다녀왔어요" {
            groupIconImageView.image = AssetsImages.cardHistoryChip20
        }
        
        registeredLabel.text = "등록된 정보 (\(cardInfo.infoCount))"
        toggleStackView.isHidden = cardInfo.infoHidden
        
        cardInfo.infoCount != 0 ? activateBtn() : deactivateBtn()
        
        if !cardInfo.withPeople.isEmpty {
            withPeopleView.peopleLabel.text = cardInfo.withPeople
            withPeopleView.isHidden = false
        }
        
        for (index, url) in [cardInfo.relLink1, cardInfo.relLink2, cardInfo.relLink3].enumerated() {
            if let url = url {
                urlView[index].urlLabel.text = url
                urlView[index].isHidden = false
            }
        }
        
        
    }
    
    func activateBtn() {
        registeredLabel.textColor = AssetColors.primary500
        expandMoreImageView.image = AssetsImages.expandMore16
        expandMoreImageView.tintColor = AssetColors.primary500
    }
    func deactivateBtn() {
        registeredStackView.isUserInteractionEnabled = false
        registeredLabel.textColor = AssetColors.gray300
        expandMoreImageView.image = AssetsImages.expandLess16
        expandMoreImageView.tintColor = AssetColors.gray300
    }
}


// MARK: - Configure

extension BookmarkCardTVC {
    
    private func configureContentView() {
        
        [firstUrlView, secondUrlView, thirdUrlView].forEach {
            urlView.append($0)
        }
        
        contentView.addSubviews([mainStackView, contentBorder])
        
        mainStackView.addArrangedSubview(infoView)
        
        infoView.addSubviews([placeNameStackView, addressStackView, iconStackView])
        [placeNameLabel, categoryLabel].forEach {
            placeNameStackView.addArrangedSubview($0)
        }

        [starImageView, addressBorder, addressLabel].forEach {
            addressStackView.addArrangedSubview($0)
        }

        [groupIconImageView, cardMenuBtn].forEach {
            iconStackView.addArrangedSubview($0)
        }
        
        registeredView.addSubview(registeredStackView)
        
        [registeredLabel, expandMoreImageView].forEach {
            registeredStackView.addArrangedSubview($0)
        }
        
        [registeredView, toggleStackView].forEach {
            mainStackView.addArrangedSubview($0)
        }
        
        [withPeopleView, firstUrlView, secondUrlView, thirdUrlView].forEach {
            toggleStackView.addArrangedSubview($0)
        }
        
        withPeopleView.isHidden = true
        urlView.forEach {
            $0.isHidden = true
        }
        
    }
    
}


// MARK: - Layout

extension BookmarkCardTVC {
    
    private func configureLayout() {
        contentBorder.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        mainStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-16).priority(.low)
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
        
        addressBorder.snp.makeConstraints {
            $0.height.equalTo(8)
            $0.width.equalTo(1)
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
        expandMoreImageView.snp.makeConstraints {
            $0.width.equalTo(expandMoreImageView.snp.height)
        }
        
        withPeopleView.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        urlView.forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(30)
            }
        }
    }
 
}

// MARK: - Bind

extension BookmarkCardTVC {
    
    private func bindToggle() {
        registeredStackView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self,
                      let index = self.index else { return }
                self.delegate?.infoToggle(index: index)
            })
            .disposed(by: bag)
    }
    
    private func bindMenuBtn() {
        cardMenuBtn.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self,
                      let index = self.index else { return }
                self.delegate?.showMenu(index: index)
            })
            .disposed(by: bag)
    }
    
}
