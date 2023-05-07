//
//  PostModel.swift
//  KChat
//
//  Created by Sokolov on 27.04.2023.
//

import UIKit
import RealmSwift

final class PostModel: Object {
    @Persisted var userID = ""
    @Persisted var postId = UUID().uuidString
    @Persisted var postImage = ""
    @Persisted var postText = ""
    @Persisted var likedBool = false
    @Persisted var likes = 0
    @Persisted var comments = 0
}
