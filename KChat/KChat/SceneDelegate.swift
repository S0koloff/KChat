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
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene)
        
        let keychain = KeychainSwift()
        
        FirebaseApp.configure()
        
        let config = Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
        
        let factory = ServicesFactory()

        if Auth.auth().currentUser != nil {
            let realm = try! Realm()
            
            let userId = keychain.get("id")
            let user = realm.objects(MemberModel.self).where {
                $0.id == userId!
            }
            
            guard let userF = user.first else {
                return
            }
            
            let tabBarController = TabBarController(realmService: factory.realmService(), keychain: factory.keychain())

            self.window?.rootViewController = tabBarController.createTabBarController(user: userF)
            
        } else {
            
            self.window?.rootViewController = LoginViewController(factory: factory)
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

