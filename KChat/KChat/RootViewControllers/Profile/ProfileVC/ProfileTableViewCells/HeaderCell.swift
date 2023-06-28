//
//  HeaderCell.swift
//  KChat
//
//  Created by Sokolov on 28.03.2023.
//

import UIKit

protocol ProfileHeaderProtol {
    func status(text: String, setupStatusBool: Bool, completion: @escaping (ProfileViewController.Status) -> Void)
}

class ProfileHeaderViewTable: UITableViewHeaderFooterView {
    
    var delegate: ProfileHeaderProtol!
    var setupStatusBool = false
    
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
    
    private lazy var statusTextField: UITextField = {
        let statusTextField = UITextField()
        statusTextField.placeholder = ProfileConstans.statusAlertMessage
        statusTextField.isHidden = true
        statusTextField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        statusTextField.translatesAutoresizingMaskIntoConstraints = false
        return statusTextField
    }()
    
    private lazy var birthdayLabel: UILabel = {
        let birthdayLabel = UILabel()
        birthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        birthdayLabel.textColor = .gray
        return birthdayLabel
    }()
    
    private lazy var birthdayIcon: UIImageView = {
        let birthdayIcon = UIImageView()
        birthdayIcon.image = UIImage(systemName: "birthday.cake")
        birthdayIcon.contentMode = .scaleAspectFit
        birthdayIcon.tintColor = Colors.gray
        birthdayIcon.translatesAutoresizingMaskIntoConstraints = false
        return birthdayIcon
    }()
    
    private lazy var cityLabel: UILabel = {
        let cityLabel = UILabel()
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        cityLabel.textColor = .gray
        return cityLabel
    }()
    
    private lazy var cityIcon: UIImageView = {
        let cityIcon = UIImageView()
        cityIcon.image = UIImage(named: "locationSign")!.withRenderingMode(.alwaysTemplate)
        cityIcon.tintColor = Colors.gray
        cityIcon.contentMode = .scaleAspectFit
        cityIcon.tintColor = UIColor(red: 0.17, green: 0.22, blue: 0.25, alpha: 1.00)
        cityIcon.translatesAutoresizingMaskIntoConstraints = false
        return cityIcon
    }()
    
    private lazy var setProfileButton = CustomButton(title: ProfileConstans.settingsButtonTitle, titleColor: .white, backgroundButtonColor: UIColor(red: 1.00, green: 0.62, blue: 0.27, alpha: 1.00), cornerRadius: 10, action: {self.buttonAction()})
    
    private lazy var setSaveButton = CustomButton(title: ProfileConstans.statusButtonSave, titleColor: .white, backgroundButtonColor: UIColor(red: 1.00, green: 0.62, blue: 0.27, alpha: 1.00), cornerRadius: 10, action: {self.buttonAction()})
        
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
        self.addSubview(self.setProfileButton)
        self.addSubview(self.statusTextField)
        self.addSubview(self.setSaveButton)
        
        self.setSaveButton.isHidden = true
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
            
            self.statusTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 55),
            self.statusTextField.leftAnchor.constraint(equalTo: avatarImage.rightAnchor, constant: 16),
            self.statusTextField.widthAnchor.constraint(equalToConstant: 300),
            
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
            
            self.setProfileButton.topAnchor.constraint(equalTo: self.birthdayIcon.bottomAnchor, constant: 16),
            self.setProfileButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.setProfileButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.setProfileButton.heightAnchor.constraint(equalToConstant: 35),
            
            self.setSaveButton.topAnchor.constraint(equalTo: self.birthdayIcon.bottomAnchor, constant: 16),
            self.setSaveButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.setSaveButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.setSaveButton.heightAnchor.constraint(equalToConstant: 35),
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
    
    @objc private func buttonAction() {
        self.delegate.status(text: statusTextField.text ?? "", setupStatusBool: setupStatusBool, completion: { [weak self] status in
            if status == .set {
                self?.setupStatusBool = true
                self?.statusLabel.isHidden = true
                self?.statusTextField.isHidden = false
                self?.statusTextField.becomeFirstResponder()
                self?.setSaveButton.isHidden = false
            } else {
                self?.setupStatusBool = false
                self?.statusLabel.isHidden = false
                self?.statusTextField.isHidden = true
                self?.statusLabel.text = self?.statusTextField.text ?? ""
                self?.setSaveButton.isHidden = true
            }
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
        avatarImage.clipsToBounds = true
    }
}

