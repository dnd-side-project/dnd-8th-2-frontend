//
//  RelatedURLButton.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/19.
//

import UIKit

import Then
import SnapKit

class RelatedURLButton: UIButton {
    
    // MARK: - UI components
    
    private let baseStackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.alignment = .center
            $0.spacing = 8.0
            $0.isUserInteractionEnabled = false
        }
    
    private let urlLabel = BaseAttributedLabel(font: AssetFonts.caption,
                                          text: nil,
                                          alignment: .left,
                                          color: AssetColors.gray700)
        .then {
            $0.lineBreakMode = .byTruncatingTail
            $0.isUserInteractionEnabled = false
        }
    
    private let arrowRightImageView = UIImageView()
        .then {
            $0.image = AssetsImages.chevronRight
            $0.isUserInteractionEnabled = false
        }
    
    // MARK: - Properties
    
    var urlString: String? {
        urlLabel.text
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        configureButton()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func setURL(_ urlString: String) {
        urlLabel.text = urlString
    }
    
}

// MARK: - Configure

extension RelatedURLButton {
    
    private func configureButton() {
        isHidden = true
        
        setBackgroundColor(AssetColors.gray100, for: .normal)
        setBackgroundColor(AssetColors.gray200, for: .highlighted)
        layer.cornerRadius = 2.0
    }
    
}

// MARK: - Layout

extension RelatedURLButton {
    
    private func configureLayout() {
        // Add Subviews
        addSubview(baseStackView)
        [urlLabel, arrowRightImageView].forEach {
            baseStackView.addArrangedSubview($0)
        }
        
        // Make Constraints
        snp.makeConstraints  {
            $0.height.equalTo(28.0)
        }
        
        baseStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(8.0)
        }
        
        urlLabel.snp.makeConstraints {
            $0.height.equalTo(28.0)
        }
        arrowRightImageView.snp.makeConstraints {
            $0.width.height.equalTo(16.0)
        }
    }
    
}
