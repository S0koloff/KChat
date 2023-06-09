//
//  AlreadyHaveAccountVC.swift
//  KChat
//
//  Created by Sokolov on 07.04.2023.
//

import UIKit
import KeychainSwift

final class AlreadyHaveAccountVC: UIViewController {
    
    private let firebaseService: FirebaseService
    private let realmService: RealmService
    private let keychain: KeychainSwift
    
    init(firebaseService: FirebaseService, realmService: RealmService, keychain: KeychainSwift) {
        self.firebaseService = firebaseService
        self.realmService = realmService
        self.keychain = keychain
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var logTitle: UILabel = {
        let logTitle = UILabel()
        logTitle.text = LoginConstans.logTitle
        logTitle.textColor = .black
        logTitle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        logTitle.textAlignment = .center
        logTitle.translatesAutoresizingMaskIntoConstraints = false
        return logTitle
    }()
    
    private lazy var logBorderView: UIView = {
        let logBorderView = UIView()
        logBorderView.layer.borderWidth = 0.8
        logBorderView.layer.cornerRadius = 10
        logBorderView.layer.borderColor = UIColor(red: 0.17, green: 0.22, blue: 0.25, alpha: 1.00).cgColor
        logBorderView.translatesAutoresizingMaskIntoConstraints = false
        return logBorderView
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
    
    private lazy var logButton = CustomButton(title: LoginConstans.logButtonTitle, titleColor: .white, backgroundButtonColor: UIColor(red: 0.17, green: 0.22, blue: 0.25, alpha: 1.00), cornerRadius: 10, action: {
        self.logButtonAction() })
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "leftArrow")!, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        self.hideKeyboardWhenTappedAround()
    }
    
    private func setupConstraints() {
        view.addSubview(self.logTitle)
        view.addSubview(self.backButton)
        view.addSubview(self.logBorderView)
        view.addSubview(self.emailImage)
        view.addSubview(self.passImage)
        view.addSubview(self.loginTextField)
        view.addSubview(self.passwordTextField)
        view.addSubview(self.logButton)
        
        NSLayoutConstraint.activate([
        
            self.logTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 148),
            self.logTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 76),
            self.logTitle.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -76),
            
            self.backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70),
            self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            
            self.logBorderView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 320),
            self.logBorderView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.logBorderView.heightAnchor.constraint(equalToConstant: 125),
            self.logBorderView.widthAnchor.constraint(equalToConstant: 300),
            
            self.emailImage.topAnchor.constraint(equalTo: self.logBorderView.topAnchor, constant: 25),
            self.emailImage.leftAnchor.constraint(equalTo: self.logBorderView.leftAnchor, constant: 25),
            self.emailImage.heightAnchor.constraint(equalToConstant: 30),
            self.emailImage.widthAnchor.constraint(equalToConstant: 30),

            self.passImage.topAnchor.constraint(equalTo: self.emailImage.bottomAnchor, constant: 20),
            self.passImage.leftAnchor.constraint(equalTo: self.logBorderView.leftAnchor, constant: 28),
            self.passImage.heightAnchor.constraint(equalToConstant: 25),
            self.passImage.widthAnchor.constraint(equalToConstant: 25),
            
            self.loginTextField.topAnchor.constraint(equalTo: self.logBorderView.topAnchor, constant: 27),
            self.loginTextField.leftAnchor.constraint(equalTo: self.logBorderView.leftAnchor, constant: 75),
            self.loginTextField.rightAnchor.constraint(equalTo: self.logBorderView.rightAnchor, constant: -55),
            self.loginTextField.heightAnchor.constraint(equalToConstant: 25),

            self.passwordTextField.centerYAnchor.constraint(equalTo: self.passImage.centerYAnchor),
            self.passwordTextField.leftAnchor.constraint(equalTo: self.logBorderView.leftAnchor, constant: 75),
            self.passwordTextField.rightAnchor.constraint(equalTo: self.logBorderView.rightAnchor, constant: -55),
            self.passwordTextField.heightAnchor.constraint(equalToConstant: 25),
            
            self.logButton.topAnchor.constraint(equalTo: self.logBorderView.bottomAnchor, constant: 63),
            self.logButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 60),
            self.logButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -60),
            self.logButton.bottomAnchor.constraint(equalTo: self.logButton.topAnchor, constant: 40),
        ])
    }
    
    @objc private func backButtonAction() {
        dismiss(animated: true)
    }
    
    @objc private func logButtonAction() {
 
        guard let email = loginTextField.text else {
            return
        }
        
        guard let pass = passwordTextField.text else {
            return
        }
        
        firebaseService.searchUser(for: email, and: pass) { result in
            switch result {
            case .success(let user):
                let tabBarController = TabBarController(realmService: self.realmService, keychain: self.keychain)
                
                let keyWindow = UIApplication
                    .shared
                    .connectedScenes
                    .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                    .last { $0.isKeyWindow }
                
                guard let window = keyWindow else {
                    return
                }

                window.rootViewController = tabBarController.createTabBarController(user: user)
                
                UIView.transition(with: window,
                                     duration: 0.3,
                                     options: .transitionCrossDissolve,
                                     animations: nil,
                                     completion: nil)
                
            case .failure(_):
                let alert = UIAlertController(title: "Connection error", message: "Please, check your internet and try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .cancel))
            }
        }
    }
}
