//
//  CategoryChipButton.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/26.
//

import UIKit

import Then
import SnapKit

class CategoryChipButton: UIButton {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    var title: String?
    var style: CategoryChipStyle
    
    // MARK: - Life Cycle
    
    /// Creates default ReetButton
    /// - Parameters:
    ///   - frame: CGRect same with the system default one.
    ///   - title: Title of the button.
    ///   - style: Style of the button, which will automatically apply its style.
    init(frame: CGRect = .zero, with title: String?, style: CategoryChipStyle) {
        self.title = title
        self.style = style
        super.init(frame: frame)
        
        configureButton(with: title, for: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override
    
    override var isEnabled: Bool {
        didSet {
            isEnabled ? configureBorderColor(state: .normal) : configureBorderColor(state: .disabled)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            configureBorderColor(state: .selected)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            configureBorderColor(state: .highlighted)
        }
    }
    
    // MARK: - Functions
}

// MARK: - Configure

extension CategoryChipButton {

    func configureButton(with title: String?, for style: CategoryChipStyle) {
        self.title = title
        self.style = style
        
        contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 12.0, bottom: 8.0, right: 12.0)
        
        configureTitleColor(title: title, state: .normal)
        configureTitleColor(title: title, state: .highlighted)
        configureTitleColor(title: title, state: .selected)
        configureTitleColor(title: title, state: .disabled)
        
        configureBackgroundColor(state: .normal)
        configureBackgroundColor(state: .highlighted)
        configureBackgroundColor(state: .selected)
        configureBackgroundColor(state: .disabled)
        
        configureBorderColor(state: .normal)
    }

    func configureTitleColor(title: String?, state: UIControl.State) {
        let safeTitle = title ?? .empty
        let attributedTitle = NSMutableAttributedString(string: safeTitle)
        
        var color: UIColor {
            switch state {
            case .normal:
                return style.normalTitleColor
            case .highlighted:
                return style.highlightedTitleColor
            case .selected:
                return style.selectedTitleColor
            case .disabled:
                return style.disabledTitleColor
            default:
                return style.normalTitleColor
            }
        }
        
        attributedTitle.setAttr(with: .chip, alignment: .center, color: color)
        setAttributedTitle(attributedTitle, for: state)
    }
    
    func configureBackgroundColor(state: UIControl.State) {
        var color: UIColor {
            switch state {
            case .normal:
                return style.normalBackgroundColor
            case .highlighted:
                return style.highlightedBackgroundColor
            case .selected:
                return style.selectedBackgroundColor
            case .disabled:
                return style.disabledBackgroundColor
            default:
                return style.normalBackgroundColor
            }
        }
        
        setBackgroundColor(color, for: state)
    }
    
    func configureBorderColor(state: UIControl.State) {
        var color: UIColor {
            switch state {
            case .normal:
                return style.normalBorderColor
            case .highlighted:
                return style.highlightedBorderColor
            case .selected:
                return style.selectedBorderColor
            case .disabled:
                return style.disabledBorderColor
            default:
                return style.normalBorderColor
            }
        }
        
        layer.borderWidth = 1.0
        layer.borderColor = color.cgColor
    }
    
}
