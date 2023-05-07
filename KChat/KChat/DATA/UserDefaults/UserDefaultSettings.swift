//
//  UserDefoultsKeys.swift
//  KChat
//
//  Created by Sokolov on 20.04.2023.
//

import UIKit

final class UserDefaultSettings {
    
    enum Keys: String {
        case userModel
    }
    
    static var userModel: UserModel! {
        get {
            guard let savedData = UserDefaults.standard.object(forKey: Keys.userModel.rawValue) as? Data, let decodedModel = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? UserModel else { return nil }
        return decodedModel
        }
        set {
            let defaults = UserDefaults.standard
            let key = Keys.userModel.rawValue
            
            if let userModel = newValue {
                if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: userModel, requiringSecureCoding: false) {
                    defaults.set(saveData, forKey: key)
                }
            }
        }
    }
    
}
