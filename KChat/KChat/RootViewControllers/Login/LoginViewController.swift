//
//  LoginViewController.swift
//  KChat
//
//  Created by Sokolov on 23.03.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class LoginViewController: UIViewController {
    
    private lazy var logoImage: UIImageView = {
        let logoImage = UIImageView()
        logoImage.image = UIImage(named: LoginConstans.logoImageLight)
        logoImage.contentMode = .scaleAspectFit
        logoImage.translatesAutoresizingMaskIntoConstraints = false
       return logoImage
    }()
    
    private lazy var loginLabel: UILabel = {
        let loginLabel = UILabel()
        loginLabel.text = LoginConstans.loginButtonTitle
        loginLabel.textColor = .black
        loginLabel.font = UIFont.systemFont(ofSize: 14)
        loginLabel.textAlignment = .center
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        return loginLabel
    }()
    
    private lazy var regButton = CustomButton(title: LoginConstans.registrationButtonTitle, titleColor: .white, backgroundButtonColor: UIColor(red: 0.17, green: 0.22, blue: 0.25, alpha: 1.00), cornerRadius: 10, action: { self.regButtonAction() })

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        loginGestureSetup()
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupConstraints() {
        self.view.addSubview(self.logoImage)
        self.view.addSubview(self.regButton)
        self.view.addSubview(self.loginLabel)
        
        NSLayoutConstraint.activate([
            self.logoImage.topAnchor.constraint(equalTo: self.logoImage.bottomAnchor, constant: -141),
            self.logoImage.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.logoImage.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.logoImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -400),
            
            self.regButton.topAnchor.constraint(equalTo: self.regButton.bottomAnchor, constant: -40),
            self.regButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 60),
            self.regButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -60),
            self.regButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -127),
            
            self.loginLabel.topAnchor.constraint(equalTo: self.regButton.bottomAnchor, constant: 27),
            self.loginLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    @objc private func regButtonAction() {
        let vc = RegViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        print("reg")
    }
    
    private func loginGestureSetup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.loginGestureAction(_:)))
        self.loginLabel.addGestureRecognizer(tapGesture)
        self.loginLabel.isUserInteractionEnabled = true
    }
    
    @objc private func loginGestureAction(_ sender: UITapGestureRecognizer) {
        let vc = AlreadyHaveAccountVC()
        self.navigationController?.pushViewController(vc, animated: true)
        print("log")
    }
}

