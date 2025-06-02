//
//  TabbarController.swift
//  RickandMorty
//
//  Created by Elnur Valizada on 19.05.25.
//

import UIKit

final class TabbarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTabs()
  }
  
  private func configureTabs() {
    let vc1 = UINavigationController(rootViewController: HomeViewController())
    let vc2 = UINavigationController(rootViewController: BookmarkViewController())
    
    
    vc1.tabBarItem.image = UIImage(systemName: "house")
    vc1.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
    vc1.tabBarItem.title = "Home"
    
    
    vc2.tabBarItem.image = UIImage(systemName: "bookmark")
    vc2.tabBarItem.selectedImage = UIImage(systemName: "bookmark.fill")
    vc2.tabBarItem.title = "Bookmarks"
    
    
    tabBar.unselectedItemTintColor = .gray
    tabBar.tintColor = .white
    tabBar.backgroundColor = .bgEnd
    
    
    setViewControllers([vc1,vc2], animated: true)
  }
}
