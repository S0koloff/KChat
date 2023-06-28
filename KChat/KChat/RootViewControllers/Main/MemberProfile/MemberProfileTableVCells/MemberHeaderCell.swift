//
//  HeaderCell.swift
//  KChat
//
//  Created by Sokolov on 12.04.2023.
//

import UIKit

class MemberProfileHeaderViewTable: UITableViewHeaderFooterView {
    
    var delegate: ProfileHeaderProtol!
    
    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor(red: 1.00, green: 0.62, blue: 0.27, alpha: 1.00).cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private lazy var surnameLabel: UILabel = {
        let surnameLabel = UILabel()
        surnameLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        surnameLabel.translatesAutoresizingMaskIntoConstraints = false
        return surnameLabel
    }()
    
    private lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        statusLabel.textColor = .gray
        return statusLabel
    }()
    
    private lazy var birthdayLabel: UILabel = {
        let birthdayLabel = UILabel()
        birthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        birthdayLabel.textColor = .gray
        return birthdayLabel
    }()
    
    private lazy var birthdayIcon: UIImageView = {
        let birthdayIcon = UIImageView()
        birthdayIcon.image = UIImage(systemName: "birthday.cake")
        birthdayIcon.contentMode = .scaleAspectFit
        birthdayIcon.tintColor = UIColor(red: 0.17, green: 0.22, blue: 0.25, alpha: 1.00)
        birthdayIcon.translatesAutoresizingMaskIntoConstraints = false
        return birthdayIcon
    }()
    
    private lazy var cityLabel: UILabel = {
        let cityLabel = UILabel()
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        cityLabel.textColor = .gray
        return cityLabel
    }()
    
    private lazy var cityIcon: UIImageView = {
        let cityIcon = UIImageView()
        cityIcon.image = UIImage(systemName: "house.and.flag")
        cityIcon.contentMode = .scaleAspectFit
        cityIcon.tintColor = UIColor(red: 0.17, green: 0.22, blue: 0.25, alpha: 1.00)
        cityIcon.translatesAutoresizingMaskIntoConstraints = false
        return cityIcon
    }()
    
    private lazy var messageToMember = CustomButton(title: ProfileConstans.messageToMember, titleColor: .white, backgroundButtonColor: UIColor(red: 1.00, green: 0.62, blue: 0.27, alpha: 1.00), cornerRadius: 10, action: {self.buttonAction()})
        
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupView()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(self.avatarImage)
        self.addSubview(self.nameLabel)
        self.addSubview(self.surnameLabel)
        self.addSubview(self.statusLabel)
        self.addSubview(self.birthdayLabel)
        self.addSubview(self.cityLabel)
        self.addSubview(self.birthdayIcon)
        self.addSubview(self.cityIcon)
        self.addSubview(self.messageToMember)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate ([
        
            self.avatarImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            self.avatarImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.avatarImage.widthAnchor.constraint(equalToConstant: 100),
            self.avatarImage.heightAnchor.constraint(equalToConstant: 100),
            
            self.nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 27),
            self.nameLabel.leftAnchor.constraint(equalTo: avatarImage.rightAnchor, constant: 16),
            
            self.surnameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 27),
            self.surnameLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 6),
            
            self.statusLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 55),
            self.statusLabel.leftAnchor.constraint(equalTo: avatarImage.rightAnchor, constant: 16),
            self.statusLabel.widthAnchor.constraint(equalToConstant: 300),
            
            self.birthdayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 90),
            self.birthdayLabel.leftAnchor.constraint(equalTo: self.birthdayIcon.rightAnchor, constant: 6),
            
            self.birthdayIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 85),
            self.birthdayIcon.leftAnchor.constraint(equalTo: avatarImage.rightAnchor, constant: 16),
            self.birthdayIcon.widthAnchor.constraint(equalToConstant: 25),
            self.birthdayIcon.heightAnchor.constraint(equalToConstant: 25),
            
            self.cityLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 90),
            self.cityLabel.leftAnchor.constraint(equalTo: self.cityIcon.rightAnchor, constant: 6),
            self.cityLabel.widthAnchor.constraint(equalToConstant: 100),
            
            self.cityIcon.centerYAnchor.constraint(equalTo: self.birthdayIcon.centerYAnchor),
            self.cityIcon.leftAnchor.constraint(equalTo: self.birthdayLabel.rightAnchor, constant: 6),
            self.cityIcon.widthAnchor.constraint(equalToConstant: 25),
            self.cityIcon.heightAnchor.constraint(equalToConstant: 25),
            
            self.messageToMember.topAnchor.constraint(equalTo: self.birthdayIcon.bottomAnchor, constant: 16),
            self.messageToMember.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.messageToMember.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.messageToMember.heightAnchor.constraint(equalToConstant: 35),
            
        ])
    }
    
    func setup(with profile: MemberModel) {
        self.avatarImage.image = UIImage(data: profile.avatar)
        self.nameLabel.text = profile.name
        self.surnameLabel.text = profile.surname
        self.statusLabel.text = profile.status
        self.cityLabel.text = profile.city
        self.birthdayLabel.text = profile.birthday
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
        avatarImage.clipsToBounds = true
    }
    
    @objc private func buttonAction() {
        print("Message")
    }
}
