//
//  PostsHeader.swift
//  KChat
//
//  Created by Sokolov on 12.04.2023.
//

import UIKit
protocol MemberPostsHeaderProtocol {
    func createPost()
}

class MemberPostsHeaderCell: UITableViewHeaderFooterView {
    
    var delegate: MemberPostsHeaderProtocol!
    
    private lazy var labelPosts: UILabel = {
        let labelPosts = UILabel()
        labelPosts.translatesAutoresizingMaskIntoConstraints = false
        labelPosts.text = ProfileConstans.myPostsTitle
        labelPosts.font = .systemFont(ofSize: 20, weight: .semibold)
        labelPosts.textColor = .black
        return labelPosts
    }()
    
    private lazy var rightImage: UIImageView = {
        let rightImage = UIImageView()
        rightImage.translatesAutoresizingMaskIntoConstraints = false
        rightImage.contentMode = .scaleAspectFit
        rightImage.image = UIImage(systemName: "square.and.pencil")
        rightImage.tintColor = .black
        return rightImage
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupView()
        self.setupConstraints() 
        self.setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(self.labelPosts)
        self.addSubview(self.rightImage)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate ([
            
            self.labelPosts.topAnchor.constraint(equalTo: self.topAnchor),
            self.labelPosts.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.labelPosts.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            
            self.rightImage.centerYAnchor.constraint(equalTo: self.labelPosts.centerYAnchor),
            self.rightImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),
            self.rightImage.widthAnchor.constraint(equalToConstant: 25),
            self.rightImage.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    private func setupGesture() {
        let createPostTap = UITapGestureRecognizer(target: self, action: #selector(self.createPostAction(_:)))
        rightImage.isUserInteractionEnabled = true
        rightImage.addGestureRecognizer(createPostTap)
    }
    
    @objc private func createPostAction(_ sender: UITapGestureRecognizer) {
        self.delegate.createPost()
    }
}

