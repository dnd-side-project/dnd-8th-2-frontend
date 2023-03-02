//
//  ReetTextField.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/03/02.
//

import UIKit

import Then
import SnapKit

class ReetTextField: UITextField {
    
    let style: ReetTextFieldStyle
    
    let clearView = UIView()
    
    let clearBtn = UIButton(type: .custom)
    
    init(frame: CGRect = .zero,
         style: ReetTextFieldStyle,
         placeholderString: String?,
         textString: String?) {
        self.style = style
        super.init(frame: frame)
        
        configureTextField(placeholderString: placeholderString, textString: textString)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTextField(placeholderString: String?, textString: String?) {
        
        layer.borderColor = style.borderColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 4.0
        layer.masksToBounds = true
        
        backgroundColor = style.backgroundColor
        
        addLeftPadding(padding: 12)
        font = AssetFonts.body2.font
        textColor = style.textColor
                
        if let placeholderString = placeholderString {
            attributedPlaceholder = NSAttributedString(
                string: placeholderString,
                attributes: [NSAttributedString.Key.foregroundColor: style.placeholderColor]
            )
        }
        
        if let textString = textString {
            text = textString
        }
        
        if style == .disabled {
            isUserInteractionEnabled = false
        }
        
        setClearBtn()
    }
    
}


// MARK: - Custom Clear Button

extension ReetTextField {
    
    private func setClearBtn() {
        clearBtn.setImage(AssetsImages.cancelContained24, for: .normal)
        clearBtn.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        clearBtn.contentMode = .scaleAspectFit
        clearBtn.tintColor = style.clearBtnColor
        
        clearView.frame = CGRect(x: 0, y: 0, width: 36, height: 24)
        clearView.addSubview(clearBtn)
        
        rightView = clearView
        rightViewMode = ViewMode.whileEditing
        
        clearBtn.addTarget(self, action: #selector(ReetTextField.clearField), for: .touchUpInside)
        addTarget(self, action: #selector(clearBtnIfNeeded), for: .editingDidBegin)
        addTarget(self, action: #selector(clearBtnIfNeeded), for: .editingChanged)
    }
    
    // 글자가 입력되었을 때만 표시되도록
    @objc private func clearBtnIfNeeded() {
        rightView?.isHidden = text?.isEmpty ?? true
    }
    
    // clear
    @objc private func clearField(_ sender: AnyObject) {
        text = .empty
        becomeFirstResponder()
    }
    
}
