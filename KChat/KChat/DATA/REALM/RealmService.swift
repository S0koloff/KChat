//
//  RealmService.swift
//  KChat
//
//  Created by Sokolov on 27.04.2023.
//

import UIKit
import RealmSwift

class RealmService {
    
    let realm = try! Realm()
    
    func createPost(userID: String, postImage: String, postText: String, likes: Int, comments: Int) {

        let newPost = PostModel()
        
        newPost.userID = userID
        newPost.postImage = postImage
        newPost.postText = postText
        newPost.likes = likes
        newPost.comments = comments

        try! realm.write({
            realm.add(newPost)
        })
    }
    
    func addFavoritePost(userAvatar: Data, userId: String, postId: String, postImage: String, postText: String, postLike: Int, postComments: Int, likeBool: Bool) {

        let favoritePost = FavoritePostModel()
        
        favoritePost.userAvatar = userAvatar
        favoritePost.userId = userId
        favoritePost.postId = postId
        favoritePost.postImage = postImage
        favoritePost.postText = postText
        favoritePost.postLike = postLike
        favoritePost.postComments = postComments
        favoritePost.likeBool = likeBool

        try! realm.write({
            realm.add(favoritePost)
        })
    }
    
    func addNewPhoto(photo: String) {
        
        let newPhoto = PhotoModel()
        
        newPhoto.photo = photo
        
        try! realm.write({
            realm.add(newPhoto)
        })
    }
    
    func createComment(postId: String, avatar: Data, text: String, date: String, likes: Int, userId: String) {
        
        let comment = CommentsModel()
        
        comment.postId = postId
        comment.avatar = avatar
        comment.text = text
        comment.date = date
        comment.likes = likes
        comment.userId = userId
        
        try! realm.write({
            realm.add(comment)
        })
    }
    
    func createMemberProfile(id: String, avatar: Data, name: String, surname: String, status: String, birthday: String, city: String) {
        
        let memberPorifle = MemberModel()
        
        memberPorifle.id = id
        memberPorifle.avatar = avatar
        memberPorifle.name = name
        memberPorifle.surname = surname
        memberPorifle.status = status
        memberPorifle.birthday = birthday
        memberPorifle.city = city
        
        try! realm.write({
            realm.add(memberPorifle)
        })
    }
    
    func createHistory(userId: String, avatarImage: Data, historyImage: Data) {
        
        let history = HistoryPostModel()
        
        history.userId = userId
        history.avatarImage = avatarImage
        history.historyImage = historyImage
        
        try! realm.write({
            realm.add(history)
        })
    }
}

