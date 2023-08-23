//
//  MarkerExtendedStackView.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/19.
//

import UIKit

class MarkerExtendedStackView: UIStackView {
    
    // MARK: - UI components
    
    private let markerExtendedImageView = UIImageView()
    
    private let placeNameLabel = PaddingLabel()
        .then {
            $0.textColor = AssetColors.white
            $0.font = AssetFonts.tooltip.font
            $0.edgeInset = UIEdgeInsets(top: 2.0, left: 8.0, bottom: 2.0, right: 8.0)
            
            $0.backgroundColor = AssetColors.black
            
            $0.layer.cornerRadius = 8.0
            $0.layer.masksToBounds = true
        }
    
    // MARK: - Variables and Properties
    
    private let markerIconHeight: CGFloat = 36.0
    
    // MARK: - Life Cycle
    
    init(frame: CGRect = .zero,
         placeName: String?,
         markerState: MarkerType.State) {
        super.init(frame: frame)
        
        markerExtendedImageView.image = MarkerType.extended(markerState).image
        placeNameLabel.text = placeName
        
        configureMarkerExtendedStackView()
        configureLayout()
        
        self.frame = getOwnBounds()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    /// Extended 마커 스택뷰의 고유 Bounds 값(CGRect)을 반환
    func getOwnBounds() -> CGRect {
        let labelWidth = placeNameLabel.intrinsicContentSize.width
        return CGRect(x: 0, y: 0, width: labelWidth >= markerIconHeight ? labelWidth : markerIconHeight, height: 54.0)
    }
    
}

// MARK: - Configure

extension MarkerExtendedStackView {
    
    private func configureMarkerExtendedStackView() {
        axis = .vertical
        distribution = .fill
        alignment = .center
        spacing = 2.0
    }
    
}

// MARK: - Layout

extension MarkerExtendedStackView {
    
    private func configureLayout() {
        [markerExtendedImageView,
         placeNameLabel].forEach {
            addArrangedSubview($0)
        }
        
        markerExtendedImageView.snp.makeConstraints {
            $0.width.height.equalTo(markerIconHeight)
        }
        placeNameLabel.snp.makeConstraints {
            $0.height.equalTo(placeNameLabel.layer.cornerRadius * 2.0)
        }
    }
    
}
