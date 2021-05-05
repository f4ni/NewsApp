//
//  CustomTabBarController.swift
//  newsapp
//
//  Created by f4ni on 4.05.2021.
//

import UIKit

class CustomTabBarController: UITabBarController{
    

    lazy var mainViewController: MainViewController = {
        let vc = MainViewController()
        vc.navigationItem.title = "NewsApp"
        return vc
    }()

    lazy var favoriteNewsController: FavoritesViewController = {
        let vc = FavoritesViewController()
        vc.navigationItem.title = "Favorites"
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainViewController.favNVController = favoriteNewsController
        let vc1 = UINavigationController(rootViewController: mainViewController)
        vc1.tabBarItem = UITabBarItem(title: "NewsApp", image: "🏠".image(), selectedImage: nil)

        favoriteNewsController.mainVController = mainViewController
        
        let vc2 = UINavigationController(rootViewController: favoriteNewsController)
        vc2.tabBarItem = UITabBarItem(title: "Favorites", image: "♥️".image(), selectedImage: nil)

        self.viewControllers = [ vc1, vc2]
    }
    
}
