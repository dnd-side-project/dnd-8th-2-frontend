//
//  ReetFAB.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/21.
//

import UIKit

import Then
import SnapKit

class ReetFAB: UIButton {
    
    // MARK: - UI components
    
    private let innerView = UIView()
        .then {
            $0.isUserInteractionEnabled = false
            $0.backgroundColor = AssetColors.white
            $0.clipsToBounds = true
            
            $0.addShadow()
            
            $0.layer.masksToBounds = false
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    private let iconImageView = UIImageView()
        .then {
            $0.contentMode = .scaleAspectFit
        }
    private let stackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.alignment = .center
            
            $0.isUserInteractionEnabled = false
        }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    init(frame: CGRect = .zero,
         size: ReetFABSize,
         title: String?,
         image: ReetFABImage) {
        super.init(frame: frame)
        
        configureButton(fabSize: size, fabTitle: title, fabImage: image)
        configureLayout(fabSize: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            innerView.backgroundColor = isHighlighted ? AssetColors.gray100 : AssetColors.white
        }
    }
    
    // MARK: - Functions
}

// MARK: - Configure

extension ReetFAB {
    
    private func configureButton(fabSize: ReetFABSize, fabTitle: String?, fabImage: ReetFABImage) {
        innerView.layer.cornerRadius = fabSize.height / 2
        iconImageView.image = fabImage.image
        
        if let title = fabTitle {
            let fabLabel = BaseAttributedLabel(font: fabSize.titleFont, text: title, alignment: .center, color: AssetColors.gray700)
            stackView.addArrangedSubview(fabLabel)
            stackView.spacing = fabSize.titleSpacing
        }
    }
    
}

// MARK: - Layout

extension ReetFAB {
    
    private func configureLayout(fabSize: ReetFABSize) {
        addSubview(innerView)
        
        innerView.addSubview(stackView)
        [iconImageView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        
        self.snp.makeConstraints {
            $0.height.equalTo(fabSize.height)
        }
        
        innerView.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
        stackView.snp.makeConstraints {
            $0.centerY.equalTo(innerView)
            
            $0.leading.equalTo(innerView).offset(fabSize.horizontalOffset)
            $0.trailing.equalTo(innerView).offset(-fabSize.horizontalOffset)
        }
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(fabSize.imageHeight)
        }
    }
    
}
