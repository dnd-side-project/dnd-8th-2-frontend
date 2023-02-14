//
//  ReetButton.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/11.
//

import UIKit

import Then
import SnapKit

class ReetButton: UIButton {
  
  let style: ReetButtonStyle
  
  let leftImageView = UIImageView()
    .then {
      $0.contentMode = .scaleAspectFit
    }
  
  let rightImageView = UIImageView()
    .then {
      $0.contentMode = .scaleAspectFit
    }
  
  private let stackView = UIStackView()
    .then {
      $0.isUserInteractionEnabled = false
      $0.spacing = 4.0
      $0.distribution = .fill
      $0.alignment = .fill
      $0.axis = .horizontal
    }
  
  /// Creates default ReetButton
  /// - Parameters:
  ///   - frame: CGRect same with the system default one.
  ///   - title: Title of the button.
  ///   - style: Style of the button, which will automatically apply its style.
  ///   - leftImage: Left icon image.
  ///   - rightImage: Right icon image.
  init(frame: CGRect = .zero,
       with title: String?,
       for style: ReetButtonStyle,
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
      configureButton(with: titleLabel?.text,
                      for: style)
    }
  }
  
  override func setTitle(_ title: String?, for state: UIControl.State) {
    super.setTitle(title, for: state)
    configureTitleLabel(with: title, for: state)
  }
  
  // MARK: - Configures
  
  private func configureButton(with title: String?,
                               for style: ReetButtonStyle,
                               leftImage: UIImage? = nil,
                               rightImage: UIImage? = nil) {
    // Configures image views
    [leftImageView, rightImageView].forEach { imageView in
      imageView.snp.makeConstraints {
        $0.width.equalTo(imageView.snp.height)
      }
    }
    
    // Set images
    if let leftImage = leftImage {
      leftImageView.image = leftImage
    }
    
    if let rightImage = rightImage {
      rightImageView.image = rightImage
    }
    
    // Configures stackview with other views
    addSubview(stackView)
    stackView.addArrangedSubview(leftImageView)
    
    if let titleLabel = titleLabel {
      stackView.addArrangedSubview(titleLabel)
    }
    
    stackView.addArrangedSubview(rightImageView)
    
    stackView.snp.makeConstraints {
      $0.top.leading.greaterThanOrEqualToSuperview().offset(16.0)
      $0.bottom.trailing.lessThanOrEqualToSuperview().offset(-16.0)
    }
    
    // Configure title
    
    setTitle(title, for: .normal)
    
    setTitle(title, for: .highlighted)
    
    setTitle(title, for: .disabled)
    
    // Configures background colors
    
    setBackgroundColor(style.defaultBackgroundColor,
                       for: .normal)
    
    setBackgroundColor(style.activeBackgroundColor,
                       for: .highlighted)
    
    setBackgroundColor(style.disabledBackgroundColor,
                       for: .disabled)
    
    // Configures corner
    
    layer.cornerRadius = 4.0
    layer.masksToBounds = true
    
    configureBorder()
  }
  
  /// Configures title with attributed string
  private func configureTitleLabel(with title: String?, for state: UIControl.State) {
    let safeTitle = title ?? .empty
    
    var color: UIColor {
      switch state {
      case .disabled:
        return style.disabledTitleColor
      default:
        return style.defaultTitleColor
      }
    }
    
    let normalAttrTitle = NSMutableAttributedString(string: safeTitle)
    normalAttrTitle.setAttr(with: .buttonSmall,
                                  alignment: .center,
                                  color: color)
    setAttributedTitle(normalAttrTitle,
                       for: state)
  }
  
  /// Configures border of oulined button
  private func configureBorder() {
    guard style == .outlined else { return }
    
    layer.borderWidth = 1.0
    
    if isEnabled {
      
      layer.borderColor = AssetColors.gray500.cgColor
      return
    }
    
    layer.borderColor = AssetColors.gray300.cgColor
  }
  
}
