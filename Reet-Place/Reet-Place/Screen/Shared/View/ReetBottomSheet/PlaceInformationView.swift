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
    
    private let placeNameLabel = BaseAttributedLabel(font: .h4,
                                        text: "PlaceName",
                                        alignment: .left,
                                        color: AssetColors.black)
    
    /// address, border, category 들어가는 stackView
    let addressStackView = UIStackView()
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
        addSubviews([placeNameLabel,
                    addressStackView])
        [addressLabel, addressBorder, categoryLabel].forEach {
            addressStackView.addArrangedSubview($0)
        }
        
        
        self.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        placeNameLabel.snp.makeConstraints {
            $0.top.equalTo(self)
            $0.leading.equalTo(self)
        }
        
        addressStackView.snp.makeConstraints {
            $0.leading.equalTo(self)
            $0.bottom.equalTo(self)
        }
        addressBorder.snp.makeConstraints {
            $0.height.equalTo(8.0)
            $0.width.equalTo(1.0)
        }
    }
    
}
