//
//  FirebaseService.swift
//  KChat
//
//  Created by Sokolov on 16.05.2023.
//

import UIKit
import FirebaseAuth
import KeychainSwift
import RealmSwift


protocol FirebaseServiceProtocol {
    
    func searchUser(for email: String, and password: String, completionFor completion: @escaping ((Result<MemberModel,Error>) -> Void))
    func createUser(for email: String, and password: String, completionFor completion: @escaping ((Result<MemberModel,Error>) -> Void))
    
}

class FirebaseService: FirebaseServiceProtocol {
    
    let keychain = KeychainSwift()
    
    func searchUser(for email: String, and password: String, completionFor completion: @escaping ((Result<MemberModel, Error>) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error == nil {
                let realm = try! Realm()
                let user = realm.objects(MemberModel.self).where {
                    $0.id == self.keychain.get("id")!
                }
                completion(.success(user.first!))
            } else {
                completion(.failure(error!))
            }
        }
    }
    
    func createUser(for email: String, and password: String, completionFor completion: @escaping ((Result<MemberModel, Error>) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error == nil {
                let realm = try! Realm()
                let user = realm.objects(MemberModel.self).where {
                    $0.id == self.keychain.get("id")!
                }
                print("CREATEUSER",user.first!)
                completion(.success(user.first!))
            } else {
                completion(.failure(error!))
            }
        }
    }
}
