//
//  UserModel.swift
//  KChat
//
//  Created by Sokolov on 20.04.2023.
//

import UIKit

class UserModel: NSObject, NSCoding {

    let id: String
    let avatar: UIImage
    let name: String
    let surname: String
    let status: String
    let birthday: String
    let city: String
    
    init(id: String, avatar: UIImage, name: String, surname: String, status: String, birthday: String, city: String) {
        self.id = id
        self.avatar = avatar
        self.name = name
        self.surname = surname
        self.status = status
        self.birthday = birthday
        self.city = city
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(avatar, forKey: "avatar")
        coder.encode(name, forKey: "name")
        coder.encode(surname, forKey: "surname")
        coder.encode(status, forKey: "status")
        coder.encode(birthday, forKey: "birthday")
        coder.encode(city, forKey: "city")
    }
    
    required init?(coder: NSCoder) {
        id = coder.decodeObject(forKey: "id") as? String ?? "0"
        avatar = coder.decodeObject(forKey: "avatar") as? UIImage ?? UIImage(named:"newProfileAvatar")!
        name = coder.decodeObject(forKey: "name") as? String ?? "New"
        surname = coder.decodeObject(forKey: "surname") as? String ?? "User"
        status = coder.decodeObject(forKey: "status") as? String ?? ""
        birthday = coder.decodeObject(forKey: "birthday") as? String ?? "birthday"
        city = coder.decodeObject(forKey: "city") as? String ?? "City"
    }
}
