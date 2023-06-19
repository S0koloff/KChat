//
//  ServicesFactory.swift
//  KChat
//
//  Created by Sokolov on 13.06.2023.
//

import UIKit
import KeychainSwift

protocol ServicesFactoryProtocol {
    func firebaseService() -> FirebaseService
    func realmService() -> RealmService
    func keychain() -> KeychainSwift
}

struct ServicesFactory: ServicesFactoryProtocol {
    
    func keychain() -> KeychainSwift {
        KeychainSwift()
    }
    
    func realmService() -> RealmService{
        RealmService()
    }
    
    func firebaseService() -> FirebaseService {
        FirebaseService()
    }
    
}
