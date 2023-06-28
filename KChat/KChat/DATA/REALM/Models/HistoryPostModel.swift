//
//  HistoryPostModel.swift
//  KChat
//
//  Created by Sokolov on 06.05.2023.
//

import UIKit
import RealmSwift

final class HistoryPostModel: Object {
    @Persisted var userId = ""
    @Persisted var avatarImage = Data()
    @Persisted var historyImage = Data()

}
