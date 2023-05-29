//
//  MemberPhotosCollectionVCell.swift
//  KChat
//
//  Created by Sokolov on 12.04.2023.
//

import UIKit

class MemberPhotosCollectionVCell: UICollectionViewCell {

    var photo: UIImageView = {
        let photos = UIImageView()
        photos.translatesAutoresizingMaskIntoConstraints = false
        return photos
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("lol")
    }
    
    private func setupConstraints() {
        self.contentView.addSubview(photo)
        
        NSLayoutConstraint.activate([
            photo.topAnchor.constraint(equalTo: contentView.topAnchor),
            photo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    public func configCellCollection(photo: UIImage) {
        self.photo.image = photo
    }
}
