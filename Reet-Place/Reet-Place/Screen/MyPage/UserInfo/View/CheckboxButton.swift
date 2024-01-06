//
//  CheckboxButton.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/04/26.
//

import UIKit

import RxSwift

import Then
import SnapKit

class CheckboxButton: UIButton {
    
    // MARK: - UI Components
    
    private let stackView = UIStackView()
        .then {
            $0.isUserInteractionEnabled = false
            $0.spacing = 8.0
            $0.distribution = .fill
            $0.alignment = .fill
            $0.axis = .horizontal
        }
    
    private let checkImageView = UIImageView(image: AssetsImages.deselectedCheckbox)
        .then {
            $0.contentMode = .scaleAspectFit
        }
    
    private let reasonLabel = BaseAttributedLabel(font: .body2,
                                          text: .empty,
                                          alignment: .left,
                                          color: AssetColors.black)
    
    
    // MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            checkImageView.image = isSelected ? AssetsImages.selectedCheckbox : AssetsImages.deselectedCheckbox
            isSelectedSubject.onNext(isSelected)
        }
    }
    
    let isSelectedSubject: PublishSubject<Bool> = .init()
    
    
    // MARK: - Initialize
    
    init(frame: CGRect = .zero, with title: String?) {
        super.init(frame: frame)
        
        configureButton(with: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods
    
    private func configureButton(with title: String?) {
        addSubview(stackView)
        
        [checkImageView, reasonLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        checkImageView.snp.makeConstraints {
            $0.width.equalTo(checkImageView.snp.height)
        }
        
        if let title = title {
            reasonLabel.text = title
        }
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        isSelected.toggle()
    }
}
