//
//  PlaceInfoView.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/06/22.
//

import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa
import RxGesture

class PlaceInfoView: BaseView {
    
    // MARK: - UI components
    
    private let baseStackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 8.0
        }
    
    // 1. 장소 이름, 카테고리, 그룹 구분 아이콘, 더보기 버튼 들어가는 StackView
    private let placeNameStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 8.0
        }
    private let placeNameLabel = BaseAttributedLabel(font: .subtitle1,
                                                     text: .empty,
                                                     alignment: .left,
                                                     color: AssetColors.black)
    private let categoryLabel = BaseAttributedLabel(font: .caption,
                                                    text: .empty,
                                                    alignment: .left,
                                                    color: AssetColors.gray500)
    private let groupIconImageView = UIImageView()
        .then {
            $0.contentMode = .scaleAspectFit
        }
    private let cardMenuButton = UIButton(type: .system)
        .then {
            $0.setImage(AssetsImages.cardMenu24, for: .normal)
        }
    
    // 2. 별점, 주소 들어가는 StackView
    private let addressStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.alignment = .center
            $0.spacing = 8.0
        }
    private let starLabel = BaseAttributedLabel(font: AssetFonts.caption,
                                                text: .empty,
                                                color: AssetColors.primary500)
    private let addressBorder = UIView()
        .then {
            $0.backgroundColor = AssetColors.gray300
        }
    private let addressLabel = BaseAttributedLabel(font: .caption,
                                                   text: .empty,
                                                   alignment: .center,
                                                   color: AssetColors.gray500)
    
    // 3. 등록된 정보, 토글 이미지 들어가는 StackView
    private let registeredStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.alignment = .center
            $0.spacing = 4.0
        }
    private let registeredLabel = BaseAttributedLabel(font: .caption,
                                                      text: .empty,
                                                      alignment: .left,
                                                      color: AssetColors.primary500)
    private let expandMoreImageView = UIImageView(image: AssetsImages.expandMore16)
        .then {
            $0.contentMode = .scaleAspectFit
        }
    
    // 4. 등록된 정보(함께할 사람들, 참고링크) 토글 했을 때 나오는 StackView
    private let toggleStackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 4.0
        }
    // 함께할 사람들
    private let withPeopleLabel = BaseAttributedLabel(font: .caption,
                                                      text: "WithPeopleTitle".localized,
                                                      alignment: .left,
                                                      color: AssetColors.gray700)
    private let withPeopleView = WithPeopleView()
    // 참고링크
    private let relatedUrlLabel = BaseAttributedLabel(font: .caption,
                                                      text: "RelatedUrl".localized,
                                                      alignment: .left,
                                                      color: AssetColors.gray700)
    private let firstUrlView = RelatedUrlButton()
    private let secondUrlView = RelatedUrlButton()
    private let thirdUrlView = RelatedUrlButton()
    
    // MARK: - Variables and Properties
    
    var delegate: BookmarkCardAction?
    private var bag = DisposeBag()
    
    private var cellIndex: Int?
    
    private var urlViewList: [RelatedUrlButton] = []
    
    // MARK: - Life Cycle
    
    override func configureView() {
        super.configureView()
        
        configureURLViewList()
        bindToggle()
        bindMenuBtn()
    }
    
    override func layoutView() {
        super.layoutView()

        configureLayout()
    }
    
    // MARK: - Function
    
    /// 장소뷰(PlaceInfoView)의 정보를 입력하는 함수
    func configurePlaceInfoView(cardInfo: BookmarkCardModel, delegate: BookmarkCardAction, cellIndex: Int) {
        self.delegate = delegate
        self.cellIndex = cellIndex
        
        // 장소 이름
        placeNameLabel.text = cardInfo.placeName
        
        // 장소 분류
        categoryLabel.text = cardInfo.categoryName
        
        // 사용자의 장소 저장 분류
        var groupIconImage: UIImage?
        // TODO: - 서버 연결 후 저장 그룹 enum 타입 관리 및 localized 처리
        switch cardInfo.groupType {
        case "가고싶어요":
            groupIconImage = AssetsImages.cardWishChip20
        case "다녀왔어요":
            groupIconImage = AssetsImages.cardHistoryChip20
        default:
            groupIconImage = nil
        }
        groupIconImageView.image = groupIconImage
        
        // 사용자 별점
        var starsText: String = .empty
        for _ in 0..<cardInfo.starCount {
            starsText.append("★")
        }
        starLabel.text = starsText
        
        // 장소 주소
        addressLabel.text = cardInfo.address
        
        // 별점 유무에 따른 주소 StackView 설정
        let addressStackViewArrangeViewList = cardInfo.starCount > 0 ? [starLabel, addressBorder, addressLabel] : [addressLabel]
        addressStackViewArrangeViewList.forEach {
            addressStackView.addArrangedSubview($0)
        }
        addressStackView.addArrangedSubview(UIView())
        
        // 등록된 정보
        registeredStackView.snp.updateConstraints {
            $0.height.equalTo(cardInfo.groupType == .empty ? 0.0 : 24.0)
        }
        baseStackView.setCustomSpacing(cardInfo.groupType == .empty ? 0.0 : 8.0, after: addressStackView)
        
        registeredLabel.text = "등록된 정보 (\(cardInfo.infoCount))"
        toggleStackView.isHidden = cardInfo.infoHidden
        isActivateToggleStackView(active: cardInfo.infoCount == 0 ? false : true)
        isExpandMoreImageView(expand: cardInfo.infoHidden ? false : true)
        
        // 함께할 사람들
        if !cardInfo.withPeople.isEmpty {
            withPeopleView.peopleLabel.text = cardInfo.withPeople
            withPeopleLabel.isHidden = false
            withPeopleView.isHidden = false
        }
        
        // 참고링크
        for (index, url) in [cardInfo.relLink1, cardInfo.relLink2, cardInfo.relLink3].enumerated() {
            if let url = url {
                urlViewList[index].urlLabel.text = url
                relatedUrlLabel.isHidden = false
                urlViewList[index].isHidden = false
            }
        }

    }
    
    /// PlaceInfoView를 사용하는 셀(Cell)의 재사용 함수에서 호출되는 PlaceInfoView 재사용 함수
    func prepareForReuseCell() {
        addressStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        withPeopleView.peopleLabel.text = .empty
        [withPeopleLabel, withPeopleView, relatedUrlLabel].forEach {
            $0.isHidden = true
        }
        urlViewList.forEach {
            $0.urlLabel.text = nil
            $0.isHidden = true
        }
    }
    
    private func isActivateToggleStackView(active: Bool) {
        registeredStackView.isUserInteractionEnabled = active ? true : false
        registeredLabel.textColor = active ? AssetColors.primary500 : AssetColors.gray300
        expandMoreImageView.tintColor = active ? AssetColors.primary500 : AssetColors.gray300
    }
    
    private func isExpandMoreImageView(expand: Bool) {
        expandMoreImageView.image = expand ? AssetsImages.expandMore16 : AssetsImages.expandLess16
    }
    
}

// MARK: - Configure

extension PlaceInfoView {
    
    private func configureURLViewList() {
        [firstUrlView, secondUrlView, thirdUrlView].forEach {
            urlViewList.append($0)
        }
    }
    
}

// MARK: - Layout

extension PlaceInfoView {
    
    private func configureLayout() {
        // Add Subviews
        addSubviews([baseStackView])
        [placeNameStackView,
         addressStackView,
         registeredStackView,
         toggleStackView].forEach {
            baseStackView.addArrangedSubview($0)
        }
        baseStackView.setCustomSpacing(4.0, after: placeNameStackView)
        
        [placeNameLabel, categoryLabel, UIView(), groupIconImageView, cardMenuButton].forEach {
            placeNameStackView.addArrangedSubview($0)
        }
        
        [registeredLabel, expandMoreImageView, UIView()].forEach {
            registeredStackView.addArrangedSubview($0)
        }
        
        [withPeopleLabel,
         withPeopleView,
         relatedUrlLabel,
         firstUrlView,
         secondUrlView,
         thirdUrlView].forEach {
            toggleStackView.addArrangedSubview($0)
        }
        toggleStackView.setCustomSpacing(12.0, after: withPeopleView)
        
        // Make Constraints
        baseStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16.0).priority(.low)
            $0.horizontalEdges.equalToSuperview().inset(20.0)
        }
        
        placeNameStackView.snp.makeConstraints {
            $0.height.equalTo(24.0)
        }
        
        addressStackView.snp.makeConstraints {
            $0.height.equalTo(14.0)
        }
        addressBorder.snp.makeConstraints {
            $0.width.equalTo(1.0)
            $0.height.equalTo(8.0)
        }
        
        registeredStackView.snp.makeConstraints {
            $0.height.equalTo(0.0)
        }
        expandMoreImageView.snp.makeConstraints {
            $0.width.equalTo(expandMoreImageView.snp.height)
        }
        
        [withPeopleLabel, relatedUrlLabel].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(14.0)
            }
        }
    }
 
}

// MARK: - Bind

extension PlaceInfoView {
    
    private func bindToggle() {
        registeredStackView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self,
                      let cellIndex = self.cellIndex,
                      let delegate = self.delegate else { return }
                
                delegate.infoToggle(index: cellIndex)
            })
            .disposed(by: bag)
    }
    
    private func bindMenuBtn() {
        cardMenuButton.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self,
                      let cellIndex = self.cellIndex,
                      let owner = self.findViewController() else { return }
                
                let buttonFrameInSuperview = owner.view.convert(self.cardMenuButton.frame, from: self.placeNameStackView)
                self.delegate?.showMenu(index: cellIndex, location: buttonFrameInSuperview)
            })
            .disposed(by: bag)
    }
    
}
