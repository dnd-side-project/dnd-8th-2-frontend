//
//  TabBarItem.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/25.
//

import UIKit

/// Make tabBarItems by order declaration
enum TabBarItem: String {
    case home
    case bookmark
    case my
}

// MARK: - Case Iterable

extension TabBarItem: CaseIterable {}

// MARK: - Custom String Convertible

extension TabBarItem: CustomStringConvertible {
    var description: String {
        rawValue.capitalized.localized.uppercased()
    }
}

// MARK: - Icon Image

extension TabBarItem {
    var image: UIImage? {
        switch self {
        case .home:
            return AssetsImages.home
        case .bookmark:
            return AssetsImages.bookmark
        case .my:
            return AssetsImages.my
        }
    }
}

// MARK: - Functions

extension TabBarItem {
    func createTabBarItemVC() -> BaseViewController {
        switch self {
        case .home:
            return HomeVC()
        case .bookmark:
            return BookmarkVC()
        case .my:
            return MyPageVC()
        }
    }
}
