//
//  ServicesFactory.swift
//  KChat
//
//  Created by Sokolov on 13.06.2023.
//

import UIKit
import KeychainSwift

protocol ServicesFactoryProtocol {
    var firebaseService: FirebaseService { get }
    var realmService: RealmService { get }
    var keychain: KeychainSwift { get }
}

struct ServicesFactory: ServicesFactoryProtocol {
    
    var firebaseService: FirebaseService {
        FirebaseService()
    }
    
    var realmService: RealmService {
        RealmService()
    }
    
    var keychain: KeychainSwift {
        KeychainSwift()
    }
}
