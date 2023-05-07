//
//  HistoryView.swift
//  KChat
//
//  Created by Sokolov on 13.04.2023.
//

import UIKit

protocol HistoryProtocol {
    func openMemberProfile(profileID: String)
}

class HistoryVC: UIViewController {
    
    var historyDelelgate: HistoryProtocol?
    
    private lazy var idLabel: UILabel = {
        let idLabel = UILabel()
        idLabel.textColor = .white
        idLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        idLabel.isHidden = true
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        return idLabel
    }()
    
    private lazy var avatarImage: UIImageView = {
        let avatarImage = UIImageView()
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.layer.borderWidth = 1.5
        avatarImage.layer.borderColor = UIColor.white.cgColor
        avatarImage.isHidden = true
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        return avatarImage
    }()
    
    private lazy var historyImage: UIImageView = {
        let historyImage = UIImageView()
        historyImage.contentMode = .scaleAspectFit
        historyImage.translatesAutoresizingMaskIntoConstraints = false
        return historyImage
    }()
    
    private lazy var cancelButtonImage: UIImageView = {
        let cancelButtonImage = UIImageView()
        cancelButtonImage.contentMode = .scaleAspectFill
        cancelButtonImage.image = UIImage(named: "cancelButton")!.withRenderingMode(.alwaysTemplate)
        cancelButtonImage.tintColor = .white
        cancelButtonImage.translatesAutoresizingMaskIntoConstraints = false
        return cancelButtonImage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkGray
        setupView()
        setupConstraints()
        setupGesture()
    }
    
    func setup(with historyPost: HistoryPostModel) {
        self.idLabel.text =  historyPost.userId
        self.avatarImage.image = UIImage(data: historyPost.avatarImage)
        self.historyImage.image = UIImage(data: historyPost.historyImage)
    }
    
    
    private func setupView() {
        view.addSubview(self.idLabel)
        view.addSubview(self.avatarImage)
        view.addSubview(self.historyImage)
        view.addSubview(self.cancelButtonImage)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.avatarImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            self.avatarImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            self.avatarImage.widthAnchor.constraint(equalToConstant: 45),
            self.avatarImage.heightAnchor.constraint(equalToConstant: 45),
            
            self.idLabel.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            self.idLabel.leftAnchor.constraint(equalTo: avatarImage.rightAnchor, constant: 12),
            
            self.cancelButtonImage.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            self.cancelButtonImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
            self.cancelButtonImage.widthAnchor.constraint(equalToConstant: 20),
            self.cancelButtonImage.heightAnchor.constraint(equalToConstant: 20),
            
            self.historyImage.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 6),
            self.historyImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            self.historyImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            self.historyImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func setupGesture() {
        let swipeDownToDismiss = UISwipeGestureRecognizer()
        swipeDownToDismiss.direction = .down
        swipeDownToDismiss.addTarget(self, action: #selector(self.dismissSwipe(_:)))
        historyImage.isUserInteractionEnabled = true
        historyImage.addGestureRecognizer(swipeDownToDismiss)
        
        let cancelTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissTap(_:)))
        cancelButtonImage.isUserInteractionEnabled = true
        cancelButtonImage.addGestureRecognizer(cancelTapGesture)

        let openMemberProfileTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.openMemberProfileTap(_:)))
        avatarImage.isUserInteractionEnabled = true
        avatarImage.addGestureRecognizer(openMemberProfileTapGesture)
    }
    
    @objc private func dismissSwipe(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
    
    @objc private func dismissTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
    
    @objc private func openMemberProfileTap(_ sender: UITapGestureRecognizer) {
        historyDelelgate?.openMemberProfile(profileID: idLabel.text ?? "")
        dismiss(animated: true)
        print("porfile")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
        avatarImage.clipsToBounds = true
        avatarImage.isHidden = false
        idLabel.isHidden = false
    }
}
