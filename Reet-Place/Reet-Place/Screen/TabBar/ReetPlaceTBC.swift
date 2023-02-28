//
//  ReetPlaceTBC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import UIKit

import Then
import SnapKit

class ReetPlaceTBC: UITabBarController {
    
    // MARK: - UI components
    
    // MARK: - Variables and Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBarStyle()
        configureTabVC()
        
        setStartTabIndex(index: 0)
    }
    
    // MARK: - Functions
    
    private func makeTabVC(toAddVC: UIViewController, tabBarTitle: String, tabBarImage: UIImage?, tabBarSelectedImage: UIImage?) -> UIViewController {
        let navC = BaseNavigationController(rootViewController: toAddVC)
        navC.navigationBar.isHidden = true
        
        navC.tabBarItem = UITabBarItem(title: tabBarTitle, image: tabBarImage?.withRenderingMode(.alwaysOriginal), selectedImage: tabBarSelectedImage?.withRenderingMode(.alwaysOriginal))
        navC.tabBarItem.imageInsets = UIEdgeInsets(top: -0.5, left: -0.5, bottom: -0.5, right: -0.5)
        
        return navC
    }
    
    /// 최초 실행시 시작 탭 위치 지정
    private func setStartTabIndex(index: Int) {
        selectedIndex = index
    }
    
}

// MARK: - Configure

extension ReetPlaceTBC {
    
    /// 탭바 스타일 설정
    private func configureTabBarStyle() {
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
        
        let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.font: AssetFonts.tooltip.font, .foregroundColor: AssetColors.gray500]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.font: AssetFonts.tooltip.font, .foregroundColor: AssetColors.primary500]
        tabBar.standardAppearance = appearance
    }
    
    /// 탭별 VC 설정
    private func configureTabVC() {
        let tabMap = makeTabVC(toAddVC: HomeVC(), tabBarTitle: "Home", tabBarImage: AssetsImages.home, tabBarSelectedImage: AssetsImages.home)
        let tabBookmark = makeTabVC(toAddVC: BookmarkVC(), tabBarTitle: "bookmark", tabBarImage: AssetsImages.bookmark, tabBarSelectedImage: AssetsImages.bookmark)
        let tabMyPage = makeTabVC(toAddVC: MyPageVC(), tabBarTitle: "myPage", tabBarImage: AssetsImages.my, tabBarSelectedImage: AssetsImages.my)
        
        let tabs =  [tabMap, tabBookmark, tabMyPage]
        
        // VC에 루트로 설정
        self.setViewControllers(tabs, animated: false)
    }
    
}
