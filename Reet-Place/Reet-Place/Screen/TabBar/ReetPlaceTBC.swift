//
//  ReetPlaceTBC.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import UIKit

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
}

// MARK: - ReetPlace TabBarController

extension ReetPlaceTBC {
    
    /// 탭바 스타일 설정
    private func configureTabBarStyle() {
        
        print("halop")
        print("halop2")
        
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
        
        tabBar.tintColor = .main
        tabBar.unselectedItemTintColor = .lightGray
        
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowOpacity = 0.3
    }
    
    /// 탭별 VC 설정
    private func configureTabVC() {
        let tabMap = makeTabVC(toAddVC: MapVC(), tabBarTitle: "map", tabBarImage: AssetsImages.map, tabBarSelectedImage: AssetsImages.map)
        let tabBookmark = makeTabVC(toAddVC: BookmarkVC(), tabBarTitle: "bookmark", tabBarImage: AssetsImages.bookmark, tabBarSelectedImage: AssetsImages.bookmark)
        let tabMyPage = makeTabVC(toAddVC: MyPageVC(), tabBarTitle: "myPage", tabBarImage: AssetsImages.myPage, tabBarSelectedImage: AssetsImages.myPage)
        
        let tabs =  [tabMap, tabBookmark, tabMyPage]
        
        // VC에 루트로 설정
        self.setViewControllers(tabs, animated: false)
    }
    
    private func makeTabVC(toAddVC: UIViewController, tabBarTitle: String, tabBarImage: UIImage?, tabBarSelectedImage: UIImage?) -> UIViewController {
        toAddVC.tabBarItem = UITabBarItem(title: tabBarTitle, image: tabBarImage?.withRenderingMode(.alwaysOriginal), selectedImage: tabBarSelectedImage?.withRenderingMode(.alwaysOriginal))
        toAddVC.tabBarItem.imageInsets = UIEdgeInsets(top: -0.5, left: -0.5, bottom: -0.5, right: -0.5)
        
        return toAddVC
    }
    
    /// 최초 실행시 시작 탭 위치 지정
    private func setStartTabIndex(index: Int) {
        selectedIndex = index
    }
    
}
