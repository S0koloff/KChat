//
//  ChatCell.swift
//  KChat
//
//  Created by Sokolov on 04.04.2023.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    private lazy var avatarImage: UIImageView = {
        let avatarImage = UIImageView()
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        return avatarImage
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .black
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.textColor = .black
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        return messageLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("lol")
    }
    
    func setup(user: MemberModel, message: String) {
        self.avatarImage.image = UIImage(data: user.avatar)
        self.nameLabel.text = user.id
        self.messageLabel.text = message
     }
    
    private func setupConstraints() {
        contentView.addSubview(avatarImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            
            self.avatarImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.avatarImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.avatarImage.widthAnchor.constraint(equalToConstant: 55),
            self.avatarImage.heightAnchor.constraint(equalToConstant: 55),
            
            self.nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            self.nameLabel.leftAnchor.constraint(equalTo: self.avatarImage.rightAnchor, constant: 6),
            self.nameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            
            self.messageLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 5),
            self.messageLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12),
            self.messageLabel.leftAnchor.constraint(equalTo: self.avatarImage.rightAnchor, constant: 6),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
        avatarImage.clipsToBounds = true
    }
    
}
