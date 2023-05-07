//
//  SettingsViewController.swift
//  KChat
//
//  Created by Sokolov on 31.03.2023.
//

import Photos
import PhotosUI
import UIKit

class SettingsViewController: UIViewController {
    
    weak var profileVC: ProfileViewController?
    
    private lazy var avatarImage: UIImageView = {
        let avatarImage = UIImageView()
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.layer.borderWidth = 2
        avatarImage.layer.borderColor = Colors.gray.cgColor
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        return avatarImage
    }()
    
    private lazy var pencilImage: UIImageView = {
        let pencilImage = UIImageView()
        pencilImage.contentMode = .scaleAspectFill
        pencilImage.image = UIImage(systemName: "pencil")
        pencilImage.tintColor = Colors.gray
        pencilImage.translatesAutoresizingMaskIntoConstraints = false
        return pencilImage
    }()
    
    private lazy var idLabel: UILabel = {
        let idLabel = UILabel()
        idLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        return idLabel
    }()
    
    private lazy var settingsBorderView: UIView = {
        let settingsBorderView = UIView()
        settingsBorderView.layer.borderWidth = 0.8
        settingsBorderView.layer.cornerRadius = 10
        settingsBorderView.layer.borderColor = Colors.gray.cgColor
        settingsBorderView.translatesAutoresizingMaskIntoConstraints = false
        return settingsBorderView
    }()
    
    private lazy var infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        infoLabel.text = ProfileConstans.infoLabel
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        return infoLabel
    }()
    
    private lazy var favoritesLabel: UILabel = {
        let favoritesLabel = UILabel()
        favoritesLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        favoritesLabel.text = ProfileConstans.favoritesLabel
        favoritesLabel.translatesAutoresizingMaskIntoConstraints = false
        return favoritesLabel
    }()
    
    private lazy var passSetupLabel: UILabel = {
        let passSetupLabel = UILabel()
        passSetupLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        passSetupLabel.text = ProfileConstans.passSetupLabel
        passSetupLabel.translatesAutoresizingMaskIntoConstraints = false
        return passSetupLabel
    }()
    
    private lazy var infoIcon: UIImageView = {
        let favoritesIcon = UIImageView()
        favoritesIcon.contentMode = .scaleAspectFit
        favoritesIcon.image = UIImage(systemName: "info.square")
        favoritesIcon.tintColor = .black
        favoritesIcon.translatesAutoresizingMaskIntoConstraints = false
        return favoritesIcon
    }()
    
    private lazy var favoritesIcon: UIImageView = {
        let favoritesIcon = UIImageView()
        favoritesIcon.contentMode = .scaleAspectFit
        favoritesIcon.image = UIImage(systemName: "bookmark")
        favoritesIcon.tintColor = .black
        favoritesIcon.translatesAutoresizingMaskIntoConstraints = false
        return favoritesIcon
    }()
    
    private lazy var passIcon: UIImageView = {
        let favoritesIcon = UIImageView()
        favoritesIcon.contentMode = .scaleAspectFit
        favoritesIcon.image = UIImage(systemName: "person.badge.key")
        favoritesIcon.tintColor = .black
        favoritesIcon.translatesAutoresizingMaskIntoConstraints = false
        return favoritesIcon
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.isHidden = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var dismissButton = CustomButton(title: "Close settings", titleColor: .white, backgroundButtonColor: Colors.gray, cornerRadius: 10, useShadow: false, action: {self.dismissAction()})
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        setupGesture()
    }
    
    private func setupView() {
        
        view.addSubview(avatarImage)
        view.addSubview(dismissButton)
        view.addSubview(idLabel)
        view.addSubview(settingsBorderView)
        view.addSubview(infoLabel)
        view.addSubview(favoritesLabel)
        view.addSubview(passSetupLabel)
        view.addSubview(infoIcon)
        view.addSubview(favoritesIcon)
        view.addSubview(passIcon)
        view.addSubview(pencilImage)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            
            avatarImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 95),
            avatarImage.widthAnchor.constraint(equalToConstant: 100),
            avatarImage.heightAnchor.constraint(equalToConstant: 100),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100),
            
            pencilImage.centerYAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: -10),
            pencilImage.leftAnchor.constraint(equalTo: avatarImage.rightAnchor, constant: -22),
            pencilImage.widthAnchor.constraint(equalToConstant: 25),
            pencilImage.heightAnchor.constraint(equalToConstant: 25),
            
            idLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            idLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 16),
            
            settingsBorderView.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 22),
            settingsBorderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsBorderView.widthAnchor.constraint(equalToConstant: 300),
            settingsBorderView.bottomAnchor.constraint(equalTo: passSetupLabel.bottomAnchor, constant: 22),
            
            infoLabel.topAnchor.constraint(equalTo: settingsBorderView.topAnchor, constant: 22),
            infoLabel.leftAnchor.constraint(equalTo: settingsBorderView.leftAnchor, constant: 75),
            infoLabel.rightAnchor.constraint(equalTo: settingsBorderView.rightAnchor, constant: -25),
            infoLabel.heightAnchor.constraint(equalToConstant: 25),
            
            favoritesLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 22),
            favoritesLabel.leftAnchor.constraint(equalTo: settingsBorderView.leftAnchor, constant: 75),
            favoritesLabel.rightAnchor.constraint(equalTo: settingsBorderView.rightAnchor, constant: -25),
            favoritesLabel.heightAnchor.constraint(equalToConstant: 25),
            
            passSetupLabel.topAnchor.constraint(equalTo: favoritesLabel.bottomAnchor, constant: 22),
            passSetupLabel.leftAnchor.constraint(equalTo: settingsBorderView.leftAnchor, constant: 75),
            passSetupLabel.rightAnchor.constraint(equalTo: settingsBorderView.rightAnchor, constant: -25),
            passSetupLabel.heightAnchor.constraint(equalToConstant: 25),
            
            dismissButton.topAnchor.constraint(equalTo: settingsBorderView.bottomAnchor, constant: 63),
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.widthAnchor.constraint(equalToConstant: 300),
            dismissButton.heightAnchor.constraint(equalToConstant: 40),
            
            infoIcon.centerYAnchor.constraint(equalTo: infoLabel.centerYAnchor),
            infoIcon.leftAnchor.constraint(equalTo: settingsBorderView.leftAnchor, constant: 25),
            infoIcon.heightAnchor.constraint(equalToConstant: 30),
            infoIcon.widthAnchor.constraint(equalToConstant: 30),
            
            favoritesIcon.centerYAnchor.constraint(equalTo: favoritesLabel.centerYAnchor),
            favoritesIcon.leftAnchor.constraint(equalTo: settingsBorderView.leftAnchor, constant: 25),
            favoritesIcon.heightAnchor.constraint(equalToConstant: 30),
            favoritesIcon.widthAnchor.constraint(equalToConstant: 30),
            
            passIcon.centerYAnchor.constraint(equalTo: passSetupLabel.centerYAnchor),
            passIcon.leftAnchor.constraint(equalTo: settingsBorderView.leftAnchor, constant: 25),
            passIcon.heightAnchor.constraint(equalToConstant: 30),
            passIcon.widthAnchor.constraint(equalToConstant: 30),
            
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
        avatarImage.clipsToBounds = true
        avatarImage.image = UserDefaultSettings.userModel.avatar
        idLabel.text = UserDefaultSettings.userModel.id
    }
    
    private func setupGesture() {
        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(self.setupNewAvatarAction(_:)))
        avatarImage.isUserInteractionEnabled = true
        avatarImage.addGestureRecognizer(avatarTap)
        
        let infoTap = UITapGestureRecognizer(target: self, action: #selector(self.infoAction(_:)))
        infoLabel.isUserInteractionEnabled = true
        infoLabel.addGestureRecognizer(infoTap)
        
        let favoriteTap = UITapGestureRecognizer(target: self, action: #selector(self.favoriteAction(_:)))
        favoritesLabel.isUserInteractionEnabled = true
        favoritesLabel.addGestureRecognizer(favoriteTap)
        
        let passTap = UITapGestureRecognizer(target: self, action: #selector(self.favoriteAction(_:)))
        passSetupLabel.isUserInteractionEnabled = true
        passSetupLabel.addGestureRecognizer(passTap)
    }
    
    @objc private func infoAction(_ sender: UITapGestureRecognizer) {
        let vc = InfoSettingsViewController()
        let tr = CATransition()
        tr.duration = 0.25
        tr.type = CATransitionType.moveIn
        tr.subtype = CATransitionSubtype.fromRight
        view.window!.layer.add(tr, forKey: kCATransition)
        view.frame.origin.y = view.frame.width - 150
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
    @objc private func favoriteAction(_ sender: UITapGestureRecognizer) {
        let vc = FavoriteViewController()
        let tr = CATransition()
        tr.duration = 0.25
        tr.type = CATransitionType.moveIn
        tr.subtype = CATransitionSubtype.fromRight
        view.window!.layer.add(tr, forKey: kCATransition)
        view.frame.origin.y = view.frame.width - 150
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
    @objc private func setupNewAvatarAction(_ sender: UITapGestureRecognizer) {
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @objc private func dismissAction() {
        let tr = CATransition()
        tr.duration = 0.25
        tr.type = CATransitionType.reveal
        tr.subtype = CATransitionSubtype.fromLeft
        view.window!.layer.add(tr, forKey: kCATransition)
        dismiss(animated: false)
    }
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         
        if let image = info[.editedImage] as? UIImage {
            
            avatarImage.image = image
            
            let updateUserData = UserModel(
                id: UserDefaultSettings.userModel.id,
                avatar: image,
                name: UserDefaultSettings.userModel.name,
                surname: UserDefaultSettings.userModel.surname,
                status: UserDefaultSettings.userModel.status,
                birthday: UserDefaultSettings.userModel.birthday,
                city: UserDefaultSettings.userModel.city)

            UserDefaultSettings.userModel = updateUserData
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "settingsUpdate"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
}

