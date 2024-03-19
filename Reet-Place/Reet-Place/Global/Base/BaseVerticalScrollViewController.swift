//
//  BaseVerticalScrollViewController.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/14.
//

import UIKit
import SnapKit

class BaseVerticalScrollViewController: BaseViewController {
  let scrollView = UIScrollView()
  let contentView = UIView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    
    scrollView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.width.equalToSuperview()
    }
  }
}
