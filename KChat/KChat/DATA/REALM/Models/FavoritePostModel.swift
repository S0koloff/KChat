//
//  FavoritePostModel.swift
//  KChat
//
//  Created by Sokolov on 29.04.2023.
//

import UIKit
import RealmSwift

final class FavoritePostModel: Object {
    @Persisted var postId = ""
    @Persisted var userAvatar = Data()
    @Persisted var userId = ""
    @Persisted var postImage = ""
    @Persisted var postText = ""
    @Persisted var postLike = 0
    @Persisted var postComments = 0
    @Persisted var likeBool = false
}
