//
//  SceneDelegate.swift
//  KChat
//
//  Created by Sokolov on 23.03.2023.
//

import UIKit
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let loginVC = UINavigationController(rootViewController: LoginViewController())
    let profileVC = UINavigationController(rootViewController: ProfileViewController())
    let chatVC = UINavigationController(rootViewController: ChatViewController())

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let config = Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
        
        loginVC.tabBarItem = UITabBarItem(title: "main".localized, image: UIImage(systemName:"house"), selectedImage: UIImage(systemName:"house.fill"))
        
        profileVC.tabBarItem = UITabBarItem(title: "profile".localized, image: UIImage(systemName:"person"), selectedImage: UIImage(systemName:"person.fill"))
        
        chatVC.tabBarItem = UITabBarItem(title: "chat".localized, image: UIImage(systemName:"message"), selectedImage: UIImage(systemName:"message.fill"))
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.viewControllers = [loginVC, profileVC, chatVC]
        
        tabBarController.tabBar.tintColor = Colors.orange
        tabBarController.tabBar.unselectedItemTintColor = Colors.gray
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }


}

