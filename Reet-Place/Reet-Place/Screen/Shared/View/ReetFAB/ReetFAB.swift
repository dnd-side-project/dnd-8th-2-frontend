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
    
    enum FABsize: String {
        case small
        case large
    }
    
    enum FABimage: String {
        case map
        case filter
        case directionTool
    }
    
    let iconImageView = UIImageView()
        .then {
            $0.contentMode = .scaleAspectFit
        }
    
    private let stackView = UIStackView()
        .then {
            $0.isUserInteractionEnabled = false
            $0.distribution = .fill
            $0.alignment = .center
            $0.axis = .horizontal
        }
    
    private let innerView = UIView()
    
    
    let size: FABsize
    
    let image: FABimage
    
    let smallHeight: CGFloat = 32.0
    let largeHeight: CGFloat = 40.0
    
    
    init(frame: CGRect = .zero,
         fabSize: FABsize,
         title: String?,
         fabImage: FABimage) {
        self.size = fabSize
        self.image = fabImage
        super.init(frame: frame)
        
        configureButton(fabSize: fabSize, title: title, fabImage: fabImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            innerView.backgroundColor = isHighlighted ? AssetColors.gray100 : AssetColors.white
        }
    }
    
    private func configureButton(fabSize: FABsize, title: String?, fabImage: FABimage) {
        addSubview(innerView)
        innerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        innerView.isUserInteractionEnabled = false
        innerView.backgroundColor = AssetColors.white
        innerView.clipsToBounds = true
        
        layer.shadowColor = CGColor(red: 23.0 / 255.0, green: 23.0 / 255.0, blue: 23.0 / 255.0, alpha: 1)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 8.0
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.masksToBounds = false
        translatesAutoresizingMaskIntoConstraints = false
        
        innerView.addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        
        
        switch fabSize {
        case .small:
            setSmallButton(title: title, fabImage: fabImage)
        case .large:
            setLargeButton(title: title, fabImage: fabImage)
        }
    
    }
    
    private func setSmallButton(title: String?, fabImage: FABimage) {
        
        frame.size.height = smallHeight
        innerView.layer.cornerRadius = smallHeight / 2
        
        if let title = title {
            let fabLabel = BaseAttributedLabel(font: AssetFonts.buttonSmall, text: title, alignment: .center, color: AssetColors.gray700)
            stackView.addArrangedSubview(fabLabel)
            stackView.spacing = 6.0
        }
        
        stackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(8)
            $0.bottom.trailing.equalToSuperview().offset(-8)
            $0.height.equalTo(16.0)
        }
                
        switch fabImage {
        case .filter:
            iconImageView.image = AssetsImages.filter16
        case .directionTool:
            iconImageView.image = AssetsImages.directionTool20
        case .map:
            iconImageView.image = AssetsImages.map20
        }

    }
    
    private func setLargeButton(title: String?, fabImage: FABimage) {
        
        frame.size.height = largeHeight
        innerView.layer.cornerRadius = largeHeight / 2
        
        if let title = title {
            let fabLabel = BaseAttributedLabel(font: AssetFonts.buttonLarge, text: title, alignment: .center, color: AssetColors.gray700)
            stackView.addArrangedSubview(fabLabel)
            stackView.spacing = 8.0
        }
        
        stackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
            $0.bottom.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(20.0)
        }
                
        switch fabImage {
        case .filter:
            iconImageView.image = AssetsImages.filter16
        case .directionTool:
            iconImageView.image = AssetsImages.directionTool20
        case .map:
            iconImageView.image = AssetsImages.map20
        }
        
    }
    
    
    
}
