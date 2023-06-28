//
//  CommentsModel.swift
//  KChat
//
//  Created by Sokolov on 01.05.2023.
//

import UIKit
import RealmSwift

final class CommentsModel: Object {
    @Persisted var postId = ""
    @Persisted var commentId = UUID().uuidString
    @Persisted var userId = ""
    @Persisted var avatar = Data()
    @Persisted var text = ""
    @Persisted var date = ""
    @Persisted var likes = 0
}
 
