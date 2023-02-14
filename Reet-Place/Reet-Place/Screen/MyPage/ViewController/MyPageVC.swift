//
//  MyPageVC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import UIKit

import RxSwift
import RxCocoa

import Then
import SnapKit

class MyPageVC: BaseVerticalScrollViewController {
  
  // MARK: - UI components
  
//  let scrollView = UIScrollView()
//
//  let contentView = UIView()
  
  let stackView = UIStackView()
    .then {
      $0.alignment = .fill
      $0.distribution = .fill
      $0.axis = .vertical
      $0.spacing = 8.0
    }
  
  // MARK: - Variables and Properties
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    contentView.addSubview(stackView)
    stackView.snp.makeConstraints {
      $0.top.leading.equalToSuperview().offset(8.0)
      $0.trailing.equalToSuperview().offset(-8.0)
      $0.bottom.lessThanOrEqualToSuperview().offset(-8.0)
    }
    
    ReetButtonStyle.allCases.forEach { style in
      let btn1 = ReetButton(with: "\(style.rawValue.capitalized)",
                            for: style,
                            left: UIImage(systemName: "heart.circle"),
                            right: UIImage(systemName: "heart.circle"))
      stackView.addArrangedSubview(btn1)
      
      let btn2 = ReetButton(with: "\(style.rawValue.capitalized) Disabled",
                            for: style,
                            left: UIImage(systemName: "heart.fill"),
                            right: UIImage(systemName: "heart.fill"))
      btn2.isEnabled = false
      stackView.addArrangedSubview(btn2)
      
      [btn1, btn2].forEach { btn in
        btn.snp.makeConstraints {
          $0.height.equalTo(48.0)
        }
        
        btn.rx.tap
          .bind(onNext: {
            print("Pressed!")
          })
          .disposed(by: bag)
      }
    }
    
    AssetFonts.allCases.forEach { font in
      let label = BaseLabel(font: font,
                            text: "\(font.rawValue)\nNext Line \(font.rawValue)")
      label.numberOfLines = .zero
      label.backgroundColor = .lightGray
      stackView.addArrangedSubview(label)
    }
    
  }
  
  // MARK: - Functions
}
