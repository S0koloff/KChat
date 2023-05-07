//
//  CreatePostViewController.swift
//  KChat
//
//  Created by Sokolov on 11.04.2023.
//

import UIKit
import RealmSwift

class CreatePostViewController: UIViewController {
    
    var imageURL = ""
    
    private lazy var titleLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        infoLabel.textColor = .black
        infoLabel.text = ProfileConstans.newPostTitle
        return infoLabel
    }()
    
    private lazy var leftButton: UIImageView = {
        let leftButton = UIImageView()
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.contentMode = .scaleAspectFit
        leftButton.image = UIImage(named: "cancelButton")
        return leftButton
    }()
    
    private lazy var rightButton: UIImageView = {
        let rightButton = UIImageView()
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.contentMode = .scaleAspectFit
        rightButton.image = UIImage(systemName: "square.and.arrow.up")?.withRenderingMode(.alwaysTemplate)
        rightButton.tintColor = Colors.orange
        return rightButton
    }()

    
    private lazy var postImage: UIImageView = {
        let postImage = UIImageView()
        postImage.translatesAutoresizingMaskIntoConstraints = false
        postImage.contentMode = .redraw
        return postImage
    }()
    
    private lazy var plusImage: UIImageView = {
        let plusImage = UIImageView()
        plusImage.translatesAutoresizingMaskIntoConstraints = false
        plusImage.contentMode = .scaleAspectFit
        plusImage.image = UIImage(systemName: "plus")
        plusImage.tintColor = Colors.orange
        return plusImage
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let descriptionTextView = UITextView()
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.text = ProfileConstans.placeHolderTextField
        descriptionTextView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionTextView.textColor = .black
        return descriptionTextView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.isHidden = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        setupGesture()
        self.hideKeyboardWhenTappedAround()
    }
    
    private func setupView() {
        view.addSubview(titleLabel)
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        view.addSubview(postImage)
        view.addSubview(plusImage)
        view.addSubview(descriptionTextView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
        
            self.titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            self.titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            self.leftButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            self.leftButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            self.leftButton.widthAnchor.constraint(equalToConstant: 25),
            self.leftButton.heightAnchor.constraint(equalToConstant: 25),
            
            self.rightButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            self.rightButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            self.rightButton.widthAnchor.constraint(equalToConstant: 25),
            self.rightButton.heightAnchor.constraint(equalToConstant: 25),
            
            self.postImage.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 12),
            self.postImage.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.postImage.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.postImage.heightAnchor.constraint(equalToConstant: 350),
            
            activityIndicator.centerXAnchor.constraint(equalTo: postImage.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: postImage.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100),
            
            self.plusImage.centerXAnchor.constraint(equalTo: self.postImage.centerXAnchor),
            self.plusImage.centerYAnchor.constraint(equalTo: self.postImage.centerYAnchor),
            self.plusImage.widthAnchor.constraint(equalToConstant: 50),
            self.plusImage.heightAnchor.constraint(equalToConstant: 50),
            
            self.descriptionTextView.topAnchor.constraint(equalTo: self.postImage.bottomAnchor, constant: 6),
            self.descriptionTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.descriptionTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            self.descriptionTextView.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func setupGesture() {
        let plusTap = UITapGestureRecognizer(target: self, action: #selector(self.addImageAction(_:)))
        plusImage.isUserInteractionEnabled = true
        plusImage.addGestureRecognizer(plusTap)
        
        let rightTap = UITapGestureRecognizer(target: self, action: #selector(self.savePostAction(_:)))
        rightButton.isUserInteractionEnabled = true
        rightButton.addGestureRecognizer(rightTap)
        
        let leftTap = UITapGestureRecognizer(target: self, action: #selector(self.leftButtonAction(_:)))
        leftButton.isUserInteractionEnabled = true
        leftButton.addGestureRecognizer(leftTap)
    }
    
    @objc private func leftButtonAction(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
    
    @objc private func addImageAction(_ sender: UITapGestureRecognizer) {
        self.plusImage.isHidden = true
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    @objc private func savePostAction(_ sender: UITapGestureRecognizer) {
        
        let realmService = RealmService()
        realmService.createPost(userID: UserDefaultSettings.userModel.id,
                                postImage: imageURL,
                                postText: descriptionTextView.text,
                                likes: 0,
                                comments: 0)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "settingsUpdate"), object: nil)
        dismiss(animated: true)
    }
}

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending(imgName)
            
            let image = info[.editedImage] as! UIImage
            let data = image.pngData()! as NSData
            data.write(toFile: localPath!, atomically: true)
            let photoURL = URL.init(fileURLWithPath: localPath!)
            print("PHOTO URL:", photoURL)
            
            self.postImage.loadFrom(URLAddress: "\(photoURL)")
            self.imageURL = "\(photoURL)"
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
