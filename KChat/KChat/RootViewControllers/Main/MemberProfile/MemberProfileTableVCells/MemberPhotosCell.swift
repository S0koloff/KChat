//
//  PhotosCell.swift
//  KChat
//
//  Created by Sokolov on 12.04.2023.
//

import UIKit

class MemberPhotosTableViewCell: UITableViewCell {

    private lazy var labelPhotos: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ProfileConstans.myPhotosTitle
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        return label
    }()

    private lazy var rightArrow: UIImageView = {
        let rightArrow = UIImageView()
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        rightArrow.image = UIImage(named: "rightArrow")
        return rightArrow
    }()
    
    private lazy var windowForImage1: UIImageView = {
        let windowForImage1 = UIImageView()
        windowForImage1.translatesAutoresizingMaskIntoConstraints = false
        return windowForImage1
    }()

    private lazy var windowForImage2: UIImageView = {
        let windowForImage1 = UIImageView()
        windowForImage1.translatesAutoresizingMaskIntoConstraints = false
        return windowForImage1
    }()

    private lazy var windowForImage3: UIImageView = {
        let windowForImage1 = UIImageView()
        windowForImage1.translatesAutoresizingMaskIntoConstraints = false
        return windowForImage1
    }()
    
    private lazy var stackViewImage: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupPreviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("lol")
    }
    
    func getPreviewImage(index: Int) -> UIImageView {
        let preview = UIImageView()
        preview.translatesAutoresizingMaskIntoConstraints = false
        preview.image = MemberPhotos.shared.examples[index]
        preview.contentMode = .scaleAspectFill
        preview.layer.cornerRadius = 6
        preview.clipsToBounds = true
        return preview
    }
    
    private func setupPreviews() {
        for ind in 0...2 {
            let image = getPreviewImage(index: ind)
            stackViewImage.addArrangedSubview(image)
            NSLayoutConstraint.activate([
                image.widthAnchor.constraint(greaterThanOrEqualToConstant: (contentView.frame.width - 24) / 4),
                image.heightAnchor.constraint(equalToConstant: 90),
            ])
        }
    }
    
    
    private func setupConstraints() {
        contentView.addSubview(labelPhotos)
        contentView.addSubview(rightArrow)
        contentView.addSubview(stackViewImage)

        
        NSLayoutConstraint.activate([
            
            self.labelPhotos.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            self.labelPhotos.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            
            self.rightArrow.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            self.rightArrow.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12),
            self.rightArrow.widthAnchor.constraint(equalToConstant: 25),
            self.rightArrow.heightAnchor.constraint(equalToConstant: 25),
            
            self.stackViewImage.topAnchor.constraint(equalTo: self.labelPhotos.bottomAnchor, constant: 12),
            self.stackViewImage.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12),
            self.stackViewImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.stackViewImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
        ])
    }
    
}

