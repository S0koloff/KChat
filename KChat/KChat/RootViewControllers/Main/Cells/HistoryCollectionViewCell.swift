//
//  HistoryCollectionViewCell.swift
//  KChat
//
//  Created by Sokolov on 04.04.2023.
//

import UIKit

protocol HistoryCollectionViewCellProtocol {
    func openHistory(ownerId: String)
}

class HistoryCollectionViewCell: UICollectionViewCell {
    
    var delegateHistory: HistoryCollectionViewCellProtocol!
    
    var ownerId = ""
    
    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = self.frame.height / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(avatarImage)
        
        NSLayoutConstraint.activate([
            
            self.avatarImage.topAnchor.constraint(equalTo: self.topAnchor),
            self.avatarImage.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.avatarImage.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.avatarImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
        ])
    }
    
    func setup(historyPost: HistoryPostModel) {
        self.avatarImage.image = UIImage(data: historyPost.historyImage)
        self.ownerId = historyPost.userId
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.avatarImage.clipsToBounds = true
    }
    
    private func setupGesture() {
        let openHistoryTap = UITapGestureRecognizer(target: self, action: #selector(self.createPostAction(_:)))
        avatarImage.isUserInteractionEnabled = true
        avatarImage.addGestureRecognizer(openHistoryTap)
    }
    
    @objc private func createPostAction(_ sender: UITapGestureRecognizer) {
        self.delegateHistory.openHistory(ownerId: ownerId)
    }
}
