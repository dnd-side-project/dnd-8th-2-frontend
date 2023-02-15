//
//  BookmarkNC.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/02/14.
//

import UIKit

class BookmarkNC: BaseNavigationController {
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViewControllers([BookmarkVC()], animated: true)
    }
    
    // MARK: - Functions
}
