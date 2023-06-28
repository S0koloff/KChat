//
//  FavoriteTableViewCell.swift
//  KChat
//
//  Created by Sokolov on 05.04.2023.
//

import UIKit

protocol FavoriteCellProtocol {
    func refreshFavorites()
    func takePostId(id: String)
    func deleteFavoritePost(id: String)
    func tapToLikeTrue(id: String)
    func tapToLikeFalse(id: String)
    func openComments()
}

class FavoriteTableViewCell: UITableViewCell {
    
    var delegate: FavoriteViewController?
    var id = ""
    var likedBool = false
    var indexPatch: IndexPath!
    
    private lazy var avatarImage: UIImageView = {
        let avatarImage = UIImageView()
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        return avatarImage
    }()
    
    private lazy var menuButton: UIImageView = {
        let menuButton = UIImageView()
        menuButton.contentMode = .scaleAspectFit
        menuButton.image = UIImage(named: "postMenu")
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        return menuButton
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var subTextLabel: UILabel = {
        let subTextLabel = UILabel()
        subTextLabel.translatesAutoresizingMaskIntoConstraints = false
        subTextLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subTextLabel.textColor = .systemGray
        subTextLabel.numberOfLines = 0
        return subTextLabel
    }()
    
    private lazy var likeLabel: UILabel = {
        let likeLabel = UILabel()
        likeLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        likeLabel.translatesAutoresizingMaskIntoConstraints = false
        return likeLabel
    }()
    
    private lazy var commentsLabel: UILabel = {
        let commentsLabel = UILabel()
        commentsLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        commentsLabel.translatesAutoresizingMaskIntoConstraints = false
        return commentsLabel
    }()
    
    private lazy var likeIcon: UIImageView = {
        let likeIcon = UIImageView()
        likeIcon.contentMode = .scaleAspectFill
        likeIcon.image = UIImage(systemName: "heart")
        likeIcon.tintColor = .black
        likeIcon.translatesAutoresizingMaskIntoConstraints = false
        return likeIcon
    }()
    
    private lazy var commentsIcon: UIImageView = {
        let commentsIcon = UIImageView()
        commentsIcon.contentMode = .scaleAspectFit
        commentsIcon.image = UIImage(systemName: "message")
        commentsIcon.tintColor = .black
        commentsIcon.translatesAutoresizingMaskIntoConstraints = false
        return commentsIcon
    }()
    
    private lazy var favoritesIcon: UIImageView = {
        let favoritesIcon = UIImageView()
        favoritesIcon.contentMode = .scaleAspectFit
        favoritesIcon.image = UIImage(systemName: "bookmark.fill")
        favoritesIcon.tintColor = Colors.orange
        favoritesIcon.translatesAutoresizingMaskIntoConstraints = false
        return favoritesIcon
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
        self.setupGesture()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with post: FavoritePostModel) {
        self.id = post.postId
        self.likedBool = post.likeBool
        self.myImageView.loadFrom(URLAddress: post.postImage)
        self.subTextLabel.text = post.postText
        self.likeLabel.text = "\(post.postLike)"
        self.commentsLabel.text = "\(post.postComments)"
        self.titleLabel.text = post.userId
        self.avatarImage.image = UIImage(data: post.userAvatar)
        
    }
    
    private func setupView() {
        self.contentView.addSubview(self.myImageView)
        self.contentView.addSubview(self.avatarImage)
        self.contentView.addSubview(self.menuButton)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subTextLabel)
        self.contentView.addSubview(self.likeLabel)
        self.contentView.addSubview(self.likeIcon)
        self.contentView.addSubview(self.commentsIcon)
        self.contentView.addSubview(self.favoritesIcon)
        self.contentView.addSubview(self.commentsLabel)
        
        NSLayoutConstraint.activate([
            self.titleLabel.centerYAnchor.constraint(equalTo: self.avatarImage.centerYAnchor),
            self.titleLabel.leftAnchor.constraint(equalTo: self.avatarImage.rightAnchor, constant: 16),
            
            self.avatarImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            self.avatarImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.avatarImage.widthAnchor.constraint(equalToConstant: 40),
            self.avatarImage.heightAnchor.constraint(equalToConstant: 40),
            
            self.menuButton.centerYAnchor.constraint(equalTo: self.avatarImage.centerYAnchor),
            self.menuButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            self.menuButton.widthAnchor.constraint(equalToConstant: 13),
            self.menuButton.heightAnchor.constraint(equalToConstant: 22),
            
            self.myImageView.topAnchor.constraint(equalTo: self.avatarImage.bottomAnchor, constant: 8),
            self.myImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.myImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.myImageView.bottomAnchor.constraint(equalTo: self.subTextLabel.topAnchor, constant: -16),
            
            
            self.subTextLabel.topAnchor.constraint(equalTo: self.myImageView.bottomAnchor, constant: 16),
            self.subTextLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 15),
            self.subTextLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -15),
            self.subTextLabel.bottomAnchor.constraint(equalTo: self.likeLabel.topAnchor, constant: -16),
            
            self.likeIcon.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            self.likeIcon.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.likeIcon.widthAnchor.constraint(equalToConstant: 25),
            self.likeIcon.heightAnchor.constraint(equalToConstant: 25),
            
            self.likeLabel.centerYAnchor.constraint(equalTo: self.commentsIcon.centerYAnchor),
            self.likeLabel.leftAnchor.constraint(equalTo: self.likeIcon.rightAnchor, constant: 6),
            
            self.commentsIcon.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            self.commentsIcon.leftAnchor.constraint(equalTo: self.likeLabel.rightAnchor, constant: 16),
            self.commentsIcon.widthAnchor.constraint(equalToConstant: 25),
            self.commentsIcon.heightAnchor.constraint(equalToConstant: 25),
            
            self.commentsLabel.centerYAnchor.constraint(equalTo: self.commentsIcon.centerYAnchor),
            self.commentsLabel.leftAnchor.constraint(equalTo: self.commentsIcon.rightAnchor, constant: 6),
            
            self.favoritesIcon.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            self.favoritesIcon.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            self.favoritesIcon.widthAnchor.constraint(equalToConstant: 30),
            self.favoritesIcon.heightAnchor.constraint(equalToConstant: 25),
            
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
        avatarImage.clipsToBounds = true
        
        if likedBool == true {
            self.likeIcon.image = UIImage(systemName: "heart.fill")
            self.likeIcon.tintColor = Colors.orange
        } else {
            self.likeIcon.image = UIImage(systemName: "heart")
            self.likeIcon.tintColor = .black
        }
    }
    
    private func setupGesture() {
        let commentsTap = UITapGestureRecognizer(target: self, action: #selector(self.commentsAction(_:)))
        commentsIcon.isUserInteractionEnabled = true
        commentsIcon.addGestureRecognizer(commentsTap)
        
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(self.likeAction(_:)))
        likeIcon.isUserInteractionEnabled = true
        likeIcon.addGestureRecognizer(likeTap)
        
        let favoriteTap = UITapGestureRecognizer(target: self, action: #selector(self.favoriteAction(_:)))
        favoritesIcon.isUserInteractionEnabled = true
        favoritesIcon.addGestureRecognizer(favoriteTap)
    }
    
    @objc private func commentsAction(_ sender: UITapGestureRecognizer) {
        self.delegate?.takePostId(id: self.id)
        self.delegate?.openComments()
    }
    
    @objc private func favoriteAction(_ sender: UITapGestureRecognizer) {
            
        if favoritesIcon.tintColor == Colors.orange {
            self.delegate?.deleteFavoritePost(id: self.id)
        }
    }
    
    @objc private func likeAction(_ sender: UITapGestureRecognizer) {
        if likedBool == false {
            self.delegate?.tapToLikeTrue(id: id)
            self.likeIcon.image = UIImage(systemName: "heart.fill")
            self.likeIcon.tintColor = Colors.orange
        } else {
            self.delegate?.tapToLikeFalse(id: id)
            self.likeIcon.image = UIImage(systemName: "heart")
            self.likeIcon.tintColor = .black
        }
    }
}
