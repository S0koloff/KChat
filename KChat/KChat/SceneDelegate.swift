//
//  SceneDelegate.swift
//  KChat
//
//  Created by Sokolov on 23.03.2023.
//

import UIKit
import RealmSwift
import KeychainSwift
import FirebaseAuth
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    static weak var shared: SceneDelegate?
    
    var window: UIWindow?
    
    var loginVC = UINavigationController(rootViewController: LoginViewController())
    var mainVC = UINavigationController(rootViewController: MainViewController())
    let chatVC = UINavigationController(rootViewController: ChatViewController())

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        Self.shared = self
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene)
        
        let keychain = KeychainSwift()
        
        FirebaseApp.configure()
        
        let config = Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
        
        mainVC.tabBarItem = UITabBarItem(title: "main".localized, image: UIImage(systemName:"house"), selectedImage: UIImage(systemName:"house.fill"))
        
        chatVC.tabBarItem = UITabBarItem(title: "chat".localized, image: UIImage(systemName:"message"), selectedImage: UIImage(systemName:"message.fill"))

        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .white

        tabBarController.tabBar.tintColor = Colors.orange
        tabBarController.tabBar.unselectedItemTintColor = Colors.gray
        

        if keychain.get("loggedIn") != nil {
            let realm = try! Realm()
            let keychain = KeychainSwift()
            
            let userId = keychain.get("id")
            let user = realm.objects(MemberModel.self).where {
                $0.id == userId!
            }
            let profileVC = UINavigationController(rootViewController: ProfileViewController(user: user.first!))
            profileVC.tabBarItem = UITabBarItem(title: "profile".localized, image: UIImage(systemName:"person"), selectedImage: UIImage(systemName:"person.fill"))
            tabBarController.viewControllers = [mainVC, profileVC, chatVC]
            self.window?.rootViewController = tabBarController
        } else {
            tabBarController.viewControllers = [loginVC]
            self.window?.rootViewController = tabBarController
        }
        self.window?.makeKeyAndVisible()
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

