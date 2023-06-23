//
//  ReetTabButton.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/05/03.
//

import UIKit

import Then
import SnapKit

class ReetTabButton: UIButton {
    
    // MARK: - UI components
    
    private let badgeView = UIView()
        .then {
            $0.backgroundColor = AssetColors.primary500
            $0.layer.cornerRadius = 2.0
            $0.layer.masksToBounds = true
        }
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    /// Creates default ReetTabButton
    /// - Parameters:
    ///   - frame: CGRect same with the system default one.
    ///   - title: Title of the button.
    ///   - style: Style of the button, which will automatically apply its style.
    init(frame: CGRect = .zero, with title: String?, style: ReetTabButtonStyle) {
        super.init(frame: frame)
        
        backgroundColor = .green
        
        configureButton(with: title, for: style)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
}

// MARK: - Configure

extension ReetTabButton {

    func configureButton(with title: String?, for style: ReetTabButtonStyle) {
        isUserInteractionEnabled = false
        
        layer.cornerRadius = 4.0
        layer.masksToBounds = true
        
        contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
        
        [UIControl.State.normal, .highlighted, .selected, .disabled].forEach {
            configureTitleColor(title: title, state: $0)
            configureBackgroundColor(state: $0)
        }
        
        badgeView.isHidden = style == .badge ? false : true
    }

    private func configureTitleColor(title: String?, state: UIControl.State) {
        let safeTitle = title ?? .empty
        let attributedTitle = NSMutableAttributedString(string: safeTitle)
        
        var color: UIColor {
            switch state {
            case .normal,
                .highlighted:
                return AssetColors.gray500
            case .selected:
                return AssetColors.primary500
            case .disabled:
                return AssetColors.gray300
            default:
                return AssetColors.gray500
            }
        }
        
        attributedTitle.setAttr(with: .subtitle1, alignment: .center, color: color)
        setAttributedTitle(attributedTitle, for: state)
    }
    
    private func configureBackgroundColor(state: UIControl.State) {
        var color: UIColor {
            switch state {
            case .normal,
                .selected,
                .disabled:
                return AssetColors.white
            case .highlighted:
                return AssetColors.gray100
            default:
                return AssetColors.white
            }
        }
        
        setBackgroundColor(color, for: state)
    }
    
}

// MARK: - Layout

extension ReetTabButton {
    
    private func configureLayout() {
        addSubviews([badgeView])
        
        badgeView.snp.makeConstraints {
            $0.width.height.equalTo(badgeView.layer.cornerRadius * 2.0)
            
            $0.top.equalTo(self).offset(6.0)
            $0.trailing.equalTo(self).offset(-2.0)
        }
    }
    
}
