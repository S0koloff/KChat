//
//  MemberModel.swift
//  KChat
//
//  Created by Sokolov on 06.05.2023.
//

import UIKit
import RealmSwift

final class MemberModel: Object {
    @Persisted var id = ""
    @Persisted var avatar = Data()
    @Persisted var name = ""
    @Persisted var surname = ""
    @Persisted var status = ""
    @Persisted var birthday = ""
    @Persisted var city = ""
}
