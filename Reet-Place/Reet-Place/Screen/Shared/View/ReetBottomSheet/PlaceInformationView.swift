//
//  PlaceInformationView.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/03/03.
//

import UIKit

import SnapKit
import Then

/// Bottom Sheet - Place Name, address, category 들어가는 View
class PlaceInformationView: BaseView {
    
    // MARK: - UI components
    
    private let baseStackView = UIStackView()
        .then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .leading
            $0.spacing = 8.0
        }
    
    private var placeNameLabel = BaseAttributedLabel(font: .h4,
                                        text: "PlaceName",
                                        alignment: .left,
                                        color: AssetColors.black)
    
    /// address, border, category 들어가는 stackView
    private let addressStackView = UIStackView()
        .then {
            $0.spacing = 8.0
            $0.distribution = .fill
            $0.alignment = .center
            $0.axis = .horizontal
        }
    private let addressLabel = BaseAttributedLabel(font: .caption,
                                           text: "Address",
                                           alignment: .center,
                                           color: AssetColors.gray700)
    private let addressBorder = UIView()
        .then {
            $0.backgroundColor = AssetColors.gray500
        }
    private let categoryLabel = BaseAttributedLabel(font: .caption,
                                            text: "PlaceCategory",
                                            alignment: .center,
                                            color: AssetColors.gray700)
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    init(frame: CGRect = .zero,
         placeNameFont: AssetFonts = .h4,
         addressFont: AssetFonts = .caption,
         categoryFont: AssetFonts = .caption) {
        placeNameLabel = BaseAttributedLabel(font: placeNameFont,
                                             text: "PlaceName",
                                             alignment: .left,
                                             color: AssetColors.black)
        
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        super.configureView()
        
        configurePlaceInformationView()
    }
    
    override func layoutView() {
        super.layoutView()
        
        configureLayout()
    }
    
    // MARK: - Functions
}

// MARK: - Configure

extension PlaceInformationView {
    
    private func configurePlaceInformationView() {
        backgroundColor = AssetColors.white
    }
    
    func configurePlaceInfomation(placeName: String, address: String, category: String) {
        placeNameLabel.text = placeName
        addressLabel.text = address
        categoryLabel.text = category
    }
    
}

// MARK: - Layout

extension PlaceInformationView {
    
    private func configureLayout() {
        // Add Subviews
        addSubviews([baseStackView])
        
        [placeNameLabel,
         addressStackView].forEach {
            baseStackView.addArrangedSubview($0)
        }

        [addressLabel, addressBorder, categoryLabel].forEach {
            addressStackView.addArrangedSubview($0)
        }
        
        // Make Constraints
        snp.makeConstraints {
            $0.height.equalTo(50.0)
        }
        
        baseStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        addressBorder.snp.makeConstraints {
            $0.width.equalTo(1.0)
            $0.height.equalTo(8.0)
        }
    }
    
}
