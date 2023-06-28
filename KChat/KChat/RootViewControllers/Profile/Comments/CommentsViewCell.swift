//
//  CommentsViewCell.swift
//  KChat
//
//  Created by Sokolov on 01.05.2023.
//

import UIKit

class CommentsViewCell: UITableViewCell {
    
    var id = ""
    
    private lazy var avatarImage: UIImageView = {
        let avatarImage = UIImageView()
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        return avatarImage
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var subTextLabel: UILabel = {
        let subTextLabel = UILabel()
        subTextLabel.translatesAutoresizingMaskIntoConstraints = false
        subTextLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subTextLabel.textColor = .systemGray
        subTextLabel.numberOfLines = 0
        return subTextLabel
    }()
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        dateLabel.textColor = .systemGray
        dateLabel.numberOfLines = 0
        return dateLabel
    }()
    
    private lazy var likeIcon: UIImageView = {
        let likeIcon = UIImageView()
        likeIcon.contentMode = .scaleAspectFill
        likeIcon.image = UIImage(systemName: "heart")
        likeIcon.tintColor = .black
        likeIcon.translatesAutoresizingMaskIntoConstraints = false
        return likeIcon
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
        avatarImage.clipsToBounds = true
    }
    
    func setup(with comment: CommentsModel) {
        self.id = comment.commentId
        self.avatarImage.image = UIImage(data: comment.avatar)
        self.titleLabel.text = comment.userId
        self.subTextLabel.text = comment.text
        self.dateLabel.text = comment.date
    }
    
    private func setupView() {
        contentView.addSubview(self.avatarImage)
        contentView.addSubview(self.titleLabel)
        contentView.addSubview(self.subTextLabel)
        contentView.addSubview(self.likeIcon)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            titleLabel.leftAnchor.constraint(equalTo: avatarImage.rightAnchor, constant: 6),
            titleLabel.bottomAnchor.constraint(equalTo: avatarImage.centerYAnchor, constant: -3),
            
            self.avatarImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.avatarImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12),
            self.avatarImage.widthAnchor.constraint(equalToConstant: 30),
            self.avatarImage.heightAnchor.constraint(equalToConstant: 30),
            
            self.subTextLabel.topAnchor.constraint(equalTo: self.avatarImage.centerYAnchor),
            self.subTextLabel.leftAnchor.constraint(equalTo: self.avatarImage.rightAnchor, constant: 8),
            
            self.likeIcon.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -6),
            self.likeIcon.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12),
            self.likeIcon.widthAnchor.constraint(equalToConstant: 18),
            self.likeIcon.heightAnchor.constraint(equalToConstant: 18),
            
        ])
    }
}
