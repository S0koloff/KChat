//
//  tabBarController.swift
//  KChat
//
//  Created by Sokolov on 14.06.2023.
//

import UIKit
import KeychainSwift

final class TabBarController {
    
    private let realmService: RealmService
    private let keychain: KeychainSwift
    
    init(realmService: RealmService, keychain: KeychainSwift) {
        self.realmService = realmService
        self.keychain = keychain
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createTabBarController(user: MemberModel) -> UITabBarController {
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .white
        
        tabBarController.tabBar.tintColor = Colors.orange
        tabBarController.tabBar.unselectedItemTintColor = Colors.gray
        
        let mainVC = UINavigationController(rootViewController: MainViewController(realmService: realmService, keychain: keychain))
        let profileVC = UINavigationController(rootViewController: ProfileViewController(user: user, realmService: realmService, keychain: keychain))
        let chatVC = UINavigationController(rootViewController: ChatViewController())
        
        mainVC.tabBarItem = UITabBarItem(title: "main".localized, image: UIImage(systemName:"house"), selectedImage: UIImage(systemName:"house.fill"))
        profileVC.tabBarItem = UITabBarItem(title: "profile".localized, image: UIImage(systemName:"person"), selectedImage: UIImage(systemName:"person.fill"))
        chatVC.tabBarItem = UITabBarItem(title: "chat".localized, image: UIImage(systemName:"message"), selectedImage: UIImage(systemName:"message.fill"))
        
        tabBarController.setViewControllers([mainVC, profileVC, chatVC], animated: true)
        
        return tabBarController
    }
}
