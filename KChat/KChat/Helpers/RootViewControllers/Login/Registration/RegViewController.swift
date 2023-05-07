//
//  RegViewController.swift
//  KChat
//
//  Created by Sokolov on 25.03.2023.
//

import UIKit
import RealmSwift

class RegViewController: UIViewController {
    
    let realm = try! Realm()
    let realmService = RealmService()
    
    private lazy var regTitle: UILabel = {
        let regTitle = UILabel()
        regTitle.text = RegConstans.regTitle
        regTitle.textColor = .black
        regTitle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        regTitle.textAlignment = .center
        regTitle.translatesAutoresizingMaskIntoConstraints = false
        return regTitle
    }()
    
    private lazy var regDescriptionLabel: UILabel = {
        let regDescriptionLabel = UILabel()
        regDescriptionLabel.text = RegConstans.regDescriptionLabel
        regDescriptionLabel.textColor = UIColor(red: 0.67, green: 0.69, blue: 0.71, alpha: 1.00)
        regDescriptionLabel.font = UIFont.systemFont(ofSize: 12)
        regDescriptionLabel.textAlignment = .center
        regDescriptionLabel.numberOfLines = 0
        regDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return regDescriptionLabel
    }()
    
    private lazy var regBorderView: UIView = {
        let regBorderView = UIView()
        regBorderView.layer.borderWidth = 0.8
        regBorderView.layer.cornerRadius = 10
        regBorderView.layer.borderColor = UIColor(red: 0.17, green: 0.22, blue: 0.25, alpha: 1.00).cgColor
        regBorderView.translatesAutoresizingMaskIntoConstraints = false
        return regBorderView
    }()
    
    private lazy var emailImage: UIImageView = {
        let emailImage = UIImageView()
        emailImage.image = UIImage(systemName: "envelope")
        emailImage.tintColor = UIColor(red: 0.17, green: 0.22, blue: 0.25, alpha: 1.00)
        emailImage.contentMode = .scaleAspectFit
        emailImage.translatesAutoresizingMaskIntoConstraints = false
        return emailImage
    }()
    
    private lazy var passImage: UIImageView = {
        let passImage = UIImageView()
        passImage.image = UIImage(systemName: "key")
        passImage.tintColor = UIColor(red: 0.17, green: 0.22, blue: 0.25, alpha: 1.00)
        passImage.contentMode = .scaleAspectFit
        passImage.translatesAutoresizingMaskIntoConstraints = false
        return passImage
    }()
    
    private lazy var idImage: UIImageView = {
        let idImage = UIImageView()
        idImage.image = UIImage(systemName: "person")
        idImage.tintColor = UIColor(red: 0.17, green: 0.22, blue: 0.25, alpha: 1.00)
        idImage.contentMode = .scaleAspectFit
        idImage.translatesAutoresizingMaskIntoConstraints = false
        return idImage
    }()
    
    private lazy var loginTextField: UITextField = {
        let loginTextField = UITextField()
        loginTextField.font = .systemFont(ofSize: 16, weight: .regular)
        loginTextField.textColor = .black
        loginTextField.autocapitalizationType = .none
        loginTextField.placeholder = RegConstans.emailPlaceholder
        loginTextField.textContentType = .oneTimeCode
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        return loginTextField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.font = .systemFont(ofSize: 16, weight: .regular)
        passwordTextField.textColor = .black
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = RegConstans.passPlaceholder
        passwordTextField.textContentType = .oneTimeCode
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        return passwordTextField
    }()
    
    private lazy var idTextField: UITextField = {
        let idTextField = UITextField()
        idTextField.font = .systemFont(ofSize: 16, weight: .regular)
        idTextField.textColor = .black
        idTextField.autocapitalizationType = .none
        idTextField.placeholder = RegConstans.idPlaceHolder
        idTextField.textContentType = .oneTimeCode
        idTextField.translatesAutoresizingMaskIntoConstraints = false
        return idTextField
    }()
    
    private lazy var regButton = CustomButton(title: RegConstans.regButtonTitle, titleColor: .white, backgroundButtonColor: UIColor(red: 0.17, green: 0.22, blue: 0.25, alpha: 1.00), cornerRadius: 10, useShadow: false, action: { self.regButtonAction() })
    
    private lazy var lowerRegDescriptionLabel: UILabel = {
        let lowerRegDescriptionLabel = UILabel()
        lowerRegDescriptionLabel.text = RegConstans.lowerRegDescriptionLabel
        lowerRegDescriptionLabel.textColor = UIColor(red: 0.67, green: 0.69, blue: 0.71, alpha: 1.00)
        lowerRegDescriptionLabel.font = UIFont.systemFont(ofSize: 12)
        lowerRegDescriptionLabel.textAlignment = .center
        lowerRegDescriptionLabel.numberOfLines = 0
        lowerRegDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return lowerRegDescriptionLabel
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupNavigationBar()
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.hideKeyboardWhenTappedAround() 
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem()
        backButton.tintColor = Colors.gray
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func setupConstraints() {
        view.addSubview(self.regTitle)
        view.addSubview(self.regDescriptionLabel)
        view.addSubview(self.regBorderView)
        view.addSubview(self.emailImage)
        view.addSubview(self.passImage)
        view.addSubview(self.loginTextField)
        view.addSubview(self.passwordTextField)
        view.addSubview(self.regButton)
        view.addSubview(self.lowerRegDescriptionLabel)
        view.addSubview(self.idImage)
        view.addSubview(self.idTextField)
        
        NSLayoutConstraint.activate([
        
            self.regTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 148),
            self.regTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 76),
            self.regTitle.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -76),

            self.regDescriptionLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 269),
            self.regDescriptionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 80),
            self.regDescriptionLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -80),
            
            self.regBorderView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 320),
            self.regBorderView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.regBorderView.heightAnchor.constraint(equalToConstant: 150),
            self.regBorderView.widthAnchor.constraint(equalToConstant: 300),
            
            self.emailImage.topAnchor.constraint(equalTo: self.regBorderView.topAnchor, constant: 25),
            self.emailImage.leftAnchor.constraint(equalTo: self.regBorderView.leftAnchor, constant: 25),
            self.emailImage.heightAnchor.constraint(equalToConstant: 30),
            self.emailImage.widthAnchor.constraint(equalToConstant: 30),

            self.passImage.topAnchor.constraint(equalTo: self.emailImage.bottomAnchor, constant: 15),
            self.passImage.leftAnchor.constraint(equalTo: self.regBorderView.leftAnchor, constant: 28),
            self.passImage.heightAnchor.constraint(equalToConstant: 25),
            self.passImage.widthAnchor.constraint(equalToConstant: 25),
            
            self.idImage.topAnchor.constraint(equalTo: self.passImage.bottomAnchor, constant: 15),
            self.idImage.leftAnchor.constraint(equalTo: self.regBorderView.leftAnchor, constant: 28),
            self.idImage.heightAnchor.constraint(equalToConstant: 25),
            self.idImage.widthAnchor.constraint(equalToConstant: 25),
            
            self.loginTextField.topAnchor.constraint(equalTo: self.regBorderView.topAnchor, constant: 27),
            self.loginTextField.leftAnchor.constraint(equalTo: self.regBorderView.leftAnchor, constant: 75),
            self.loginTextField.rightAnchor.constraint(equalTo: self.regBorderView.rightAnchor, constant: -55),
            self.loginTextField.heightAnchor.constraint(equalToConstant: 25),

            self.passwordTextField.topAnchor.constraint(equalTo: self.loginTextField.bottomAnchor, constant: 17),
            self.passwordTextField.leftAnchor.constraint(equalTo: self.regBorderView.leftAnchor, constant: 75),
            self.passwordTextField.rightAnchor.constraint(equalTo: self.regBorderView.rightAnchor, constant: -55),
            self.passwordTextField.heightAnchor.constraint(equalToConstant: 25),
            
            self.idTextField.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 17),
            self.idTextField.leftAnchor.constraint(equalTo: self.regBorderView.leftAnchor, constant: 75),
            self.idTextField.rightAnchor.constraint(equalTo: self.regBorderView.rightAnchor, constant: -55),
            self.idTextField.heightAnchor.constraint(equalToConstant: 25),
            
            self.regButton.topAnchor.constraint(equalTo: self.regBorderView.bottomAnchor, constant: 63),
            self.regButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 60),
            self.regButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -60),
            self.regButton.bottomAnchor.constraint(equalTo: self.regButton.topAnchor, constant: 40),
            
            self.lowerRegDescriptionLabel.topAnchor.constraint(equalTo: self.regButton.bottomAnchor, constant: 30),
            self.lowerRegDescriptionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50),
            self.lowerRegDescriptionLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50),            
        ])
    }
    
    @objc private func regButtonAction() {
        
        if idTextField.text?.isValidId == false {
            print("Invalid ID")
        } else {
            
            UserDefaultSettings.userModel = UserModel(id: idTextField.text!, avatar: UIImage(named:"newProfileAvatar")!, name: "New", surname: "Profile", status: "zzz...", birthday: "Birthday", city: "City")
            
//             Setup Memebers for test

            realmService.createMemberProfile(id: "funny_pug", avatar: (UIImage(named: "pug")?.pngData())!, name: "Mister", surname: "Pug", status: "Zzzz...", birthday: "22 may 2014", city: "Los Angeles")
            
            realmService.createMemberProfile(id: "alex_travel", avatar: (UIImage(named: "travelAlex")?.pngData())!, name: "Alex", surname: "Savoch", status: "Life is either a daring adventure or nothing.", birthday: "9 September 1997", city: "Perm")
            
            realmService.createMemberProfile(id: UserDefaultSettings.userModel.id, avatar: UserDefaultSettings.userModel.avatar.pngData()!, name: UserDefaultSettings.userModel.name, surname: UserDefaultSettings.userModel.surname, status: UserDefaultSettings.userModel.status, birthday: UserDefaultSettings.userModel.birthday, city: UserDefaultSettings.userModel.city)
            
            realmService.createHistory(userId: "funny_pug", avatarImage: (UIImage(named: "pug")?.pngData())!, historyImage: (UIImage(named: "pug")?.pngData())!)
            realmService.createHistory(userId: "alex_travel", avatarImage: (UIImage(named: "travelAlex")?.pngData())!, historyImage: (UIImage(named: "travelAlex")?.pngData())!)
            
            realmService.createPost(userID: "funny_pug", postImage: "pug1", postText: "Wof wof", likes: 12, comments: 0)
            realmService.createPost(userID: "alex_travel", postImage: "travel2", postText: "Lets go!", likes: 213, comments: 0)
            

            let vc = MainViewController()
            self.navigationController?.setViewControllers([vc], animated: true)
        }
        
        
    }
}
