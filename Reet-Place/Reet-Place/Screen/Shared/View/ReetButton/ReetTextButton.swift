//
//  ReetTextButton.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/04/20.
//

import UIKit

import Then
import SnapKit

class ReetTextButton: UIButton {
  
    // MARK: - UI components
    
    private let stackView = UIStackView()
        .then {
            $0.axis = .horizontal
            $0.spacing = 4.0
            $0.distribution = .fillProportionally
            $0.alignment = .fill
            $0.isUserInteractionEnabled = false
        }
    private let leftImageView = UIImageView()
    private let textTitleLabel = UILabel()
        .then {
            $0.font = AssetFonts.buttonSmall.font
        }
    private let rightImageView = UIImageView()
  
    // MARK: - Variables and Properties
    
    let style: ReetTextButtonStyle
    
    // MARK: - Life Cycle
    
    /// ReetTextButon - 좌우 이미지 기본 값 nil, 특정 이미지 설정 시 이미지 뷰 생성
    init(frame: CGRect = .zero,
         with title: String?,
         for style: ReetTextButtonStyle,
         left leftImage: UIImage? = nil,
         right rightImage: UIImage? = nil) {
        self.style = style
        super.init(frame: frame)
    
        configureButton(with: title,
                        for: style,
                        leftImage: leftImage,
                        rightImage: rightImage)
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overrides
  
    override var isEnabled: Bool {
        didSet {
            textTitleLabel.textColor = isEnabled ? style.enabledTitleColor : style.diabledTitleColor
            [leftImageView, rightImageView].forEach { imageView in
                imageView.tintColor = isEnabled ? style.enabledTitleColor : style.diabledTitleColor
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            textTitleLabel.textColor = isHighlighted ? style.pressedTitleColor : style.enabledTitleColor
            [leftImageView, rightImageView].forEach { imageView in
                imageView.tintColor = isHighlighted ? style.pressedTitleColor : style.enabledTitleColor
            }
        }
    }
  
}

// MARK: - Configure

extension ReetTextButton {
    
    private func configureButton(with title: String?,
                                 for style: ReetTextButtonStyle,
                                 leftImage: UIImage? = nil,
                                 rightImage: UIImage? = nil) {
        backgroundColor = .white
        
        [leftImageView, rightImageView].forEach { imageView in
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = style.enabledTitleColor
            
            imageView.snp.makeConstraints {
                $0.width.height.equalTo(16.0)
            }
        }
        
        if let leftImage = leftImage {
            leftImageView.image = leftImage
            stackView.addArrangedSubview(leftImageView)
        }
        if let title = title {
            textTitleLabel.text = title
            textTitleLabel.textColor = style.enabledTitleColor

            stackView.addArrangedSubview(textTitleLabel)
        }
        if let rightImage = rightImage {
            rightImageView.image = rightImage
            stackView.addArrangedSubview(rightImageView)
        }

        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalTo(self).inset(16.0)
        }
    }
    
}
