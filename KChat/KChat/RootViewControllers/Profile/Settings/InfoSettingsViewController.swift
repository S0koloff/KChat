//
//  InfoSettingsViewController.swift
//  KChat
//
//  Created by Sokolov on 05.04.2023.
//

import UIKit
import RealmSwift
import KeychainSwift

class InfoSettingsViewController: UIViewController {
    
    private lazy var infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        infoLabel.textColor = .black
        infoLabel.text = ProfileConstans.navigationTitle
        return infoLabel
    }()
    
    private lazy var rightButton: UIImageView = {
        let rightButton = UIImageView()
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.contentMode = .scaleAspectFit
        rightButton.image = UIImage(named: "checkMark")
        return rightButton
    }()
    
    private lazy var leftButton: UIImageView = {
        let leftButton = UIImageView()
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.contentMode = .scaleAspectFit
        leftButton.image = UIImage(named: "cancelButton")
        return leftButton
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        nameLabel.textColor = .black
        nameLabel.text = ProfileConstans.name
        return nameLabel
    }()
    
    private lazy var nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.font = .systemFont(ofSize: 16, weight: .regular)
        nameTextField.textColor = .black
        nameTextField.autocapitalizationType = .none
        nameTextField.layer.borderWidth = 0.8
        nameTextField.layer.borderColor = Colors.gray.cgColor
        nameTextField.layer.cornerRadius = 10
        nameTextField.placeholder = ProfileConstans.name
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.leftViewMode = .always
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameTextField.frame.height))
        return nameTextField
    }()
    
    private lazy var surnameLabel: UILabel = {
        let surnameLabel = UILabel()
        surnameLabel.translatesAutoresizingMaskIntoConstraints = false
        surnameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        surnameLabel.textColor = .black
        surnameLabel.text = ProfileConstans.surname
        return surnameLabel
    }()
    
    private lazy var surnameTextField: UITextField = {
        let surnameTextField = UITextField()
        surnameTextField.font = .systemFont(ofSize: 16, weight: .regular)
        surnameTextField.textColor = .black
        surnameTextField.autocapitalizationType = .none
        surnameTextField.layer.borderWidth = 0.8
        surnameTextField.layer.borderColor = Colors.gray.cgColor
        surnameTextField.layer.cornerRadius = 10
        surnameTextField.placeholder = ProfileConstans.surname
        surnameTextField.translatesAutoresizingMaskIntoConstraints = false
        surnameTextField.leftViewMode = .always
        surnameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameTextField.frame.height))
        return surnameTextField
    }()
    
    private lazy var genderLabel: UILabel = {
        let genderLabel = UILabel()
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        genderLabel.textColor = .black
        genderLabel.text = ProfileConstans.gender
        return genderLabel
    }()
    
    private lazy var ellipseM: UIImageView = {
        let ellipseM = UIImageView()
        ellipseM.translatesAutoresizingMaskIntoConstraints = false
        ellipseM.contentMode = .scaleAspectFit
        ellipseM.image = UIImage(named: "ellipseFalse")
        return ellipseM
    }()
    
    private lazy var ellipseF: UIImageView = {
        let ellipseM = UIImageView()
        ellipseM.translatesAutoresizingMaskIntoConstraints = false
        ellipseM.contentMode = .scaleAspectFit
        ellipseM.image = UIImage(named: "ellipseFalse")
        return ellipseM
    }()
    
    private lazy var genderMLabel: UILabel = {
        let genderMLabel = UILabel()
        genderMLabel.translatesAutoresizingMaskIntoConstraints = false
        genderMLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        genderMLabel.textColor = .black
        genderMLabel.text = ProfileConstans.genderM
        return genderMLabel
    }()
    
    private lazy var genderFLabel: UILabel = {
        let genderFLabel = UILabel()
        genderFLabel.translatesAutoresizingMaskIntoConstraints = false
        genderFLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        genderFLabel.textColor = .black
        genderFLabel.text = ProfileConstans.genderF
        return genderFLabel
    }()
    
    private lazy var birthdayLabel: UILabel = {
        let birthdayLabel = UILabel()
        birthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        birthdayLabel.textColor = .black
        birthdayLabel.text = ProfileConstans.birthday
        return birthdayLabel
    }()
    
    private lazy var birthdayTextField: UITextField = {
        let birthdayTextField = UITextField()
        birthdayTextField.font = .systemFont(ofSize: 16, weight: .regular)
        birthdayTextField.textColor = .black
        birthdayTextField.autocapitalizationType = .none
        birthdayTextField.layer.borderWidth = 0.8
        birthdayTextField.layer.borderColor = Colors.gray.cgColor
        birthdayTextField.layer.cornerRadius = 10
        birthdayTextField.placeholder = ProfileConstans.birthday
        birthdayTextField.translatesAutoresizingMaskIntoConstraints = false
        birthdayTextField.leftViewMode = .always
        birthdayTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameTextField.frame.height))
        return birthdayTextField
    }()
    
    private lazy var cityLabel: UILabel = {
        let cityLabel = UILabel()
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        cityLabel.textColor = .black
        cityLabel.text = ProfileConstans.city
        return cityLabel
    }()
    
    private lazy var cityTextField: UITextField = {
        let cityTextField = UITextField()
        cityTextField.font = .systemFont(ofSize: 16, weight: .regular)
        cityTextField.textColor = .black
        cityTextField.autocapitalizationType = .none
        cityTextField.layer.borderWidth = 0.8
        cityTextField.layer.borderColor = Colors.gray.cgColor
        cityTextField.layer.cornerRadius = 10
        cityTextField.placeholder = ProfileConstans.city
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        cityTextField.leftViewMode = .always
        cityTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: nameTextField.frame.height))
        return cityTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(self.infoLabel)
        view.addSubview(self.leftButton)
        view.addSubview(self.rightButton)
        view.addSubview(self.nameLabel)
        view.addSubview(self.nameTextField)
        view.addSubview(self.surnameLabel)
        view.addSubview(self.surnameTextField)
        view.addSubview(self.genderLabel)
        view.addSubview(self.ellipseM)
        view.addSubview(self.ellipseF)
        view.addSubview(self.genderMLabel)
        view.addSubview(self.genderFLabel)
        view.addSubview(self.birthdayLabel)
        view.addSubview(self.birthdayTextField)
        view.addSubview(self.cityLabel)
        view.addSubview(self.cityTextField)
        
        setupConstraints()
        setupGesture()
        self.hideKeyboardWhenTappedAround()
        setupPicker()
        setupInfoText()
        
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            self.infoLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            self.infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            self.leftButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
            self.leftButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            self.leftButton.widthAnchor.constraint(equalToConstant: 25),
            self.leftButton.heightAnchor.constraint(equalToConstant: 25),
            
            self.rightButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
            self.rightButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            self.rightButton.widthAnchor.constraint(equalToConstant: 25),
            self.rightButton.heightAnchor.constraint(equalToConstant: 25),
            
            self.nameLabel.topAnchor.constraint(equalTo: leftButton.bottomAnchor, constant: 26),
            self.nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            
            self.nameTextField.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 6),
            self.nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            self.nameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            self.nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            self.surnameLabel.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor, constant: 12),
            self.surnameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            
            self.surnameTextField.topAnchor.constraint(equalTo: self.surnameLabel.bottomAnchor, constant: 6),
            self.surnameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            self.surnameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            self.surnameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            self.genderLabel.topAnchor.constraint(equalTo: self.surnameTextField.bottomAnchor, constant: 12),
            self.genderLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            
            self.ellipseM.topAnchor.constraint(equalTo: self.genderLabel.bottomAnchor, constant: 12),
            self.ellipseM.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            self.ellipseM.widthAnchor.constraint(equalToConstant: 20),
            self.ellipseM.heightAnchor.constraint(equalToConstant: 20),
            
            self.genderMLabel.centerYAnchor.constraint(equalTo: self.ellipseM.centerYAnchor),
            self.genderMLabel.leftAnchor.constraint(equalTo: self.ellipseM.rightAnchor, constant: 16),
            
            self.ellipseF.topAnchor.constraint(equalTo: self.ellipseM.bottomAnchor, constant: 12),
            self.ellipseF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            self.ellipseF.widthAnchor.constraint(equalToConstant: 20),
            self.ellipseF.heightAnchor.constraint(equalToConstant: 20),
            
            self.genderFLabel.centerYAnchor.constraint(equalTo: self.ellipseF.centerYAnchor),
            self.genderFLabel.leftAnchor.constraint(equalTo: self.ellipseF.rightAnchor, constant: 16),
            
            self.birthdayLabel.topAnchor.constraint(equalTo: self.ellipseF.bottomAnchor, constant: 12),
            self.birthdayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            
            self.birthdayTextField.topAnchor.constraint(equalTo: self.birthdayLabel.bottomAnchor, constant: 6),
            self.birthdayTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            self.birthdayTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            self.birthdayTextField.heightAnchor.constraint(equalToConstant: 40),
            
            self.cityLabel.topAnchor.constraint(equalTo: self.birthdayTextField.bottomAnchor, constant: 12),
            self.cityLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            
            self.cityTextField.topAnchor.constraint(equalTo: self.cityLabel.bottomAnchor, constant: 6),
            self.cityTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            self.cityTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            self.cityTextField.heightAnchor.constraint(equalToConstant: 40),
            
        ])
    }
    
    private func setupInfoText() {
        let realm = try! Realm()
        let keychain = KeychainSwift()
        guard let userId = keychain.get("id") else {
            return
        }
        let user = realm.objects(MemberModel.self).where {
            $0.id == userId
        }
        guard user.first != nil else {
            return
        }
        self.nameTextField.text = self.findUser().name
        self.surnameTextField.text = self.findUser().surname
        self.birthdayTextField.text = self.findUser().birthday
        self.cityTextField.text = self.findUser().city
    }
    
    private func setupPicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        
        birthdayTextField.inputView = datePicker
    }
    
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        birthdayTextField.text = formatDate(date: datePicker.date)
    }
    
    private func setupGesture() {
        let leftTap = UITapGestureRecognizer(target: self, action: #selector(self.leftButtonAction(_:)))
        leftButton.isUserInteractionEnabled = true
        leftButton.addGestureRecognizer(leftTap)
        
        let rightTap = UITapGestureRecognizer(target: self, action: #selector(self.rightButtonAction(_:)))
        rightButton.isUserInteractionEnabled = true
        rightButton.addGestureRecognizer(rightTap)
        
        let ellipseMTap = UITapGestureRecognizer(target: self, action: #selector(self.ellipseMButtonAction(_:)))
        ellipseM.isUserInteractionEnabled = true
        ellipseM.addGestureRecognizer(ellipseMTap)
        
        let ellipseFTap = UITapGestureRecognizer(target: self, action: #selector(self.ellipseFButtonAction(_:)))
        ellipseF.isUserInteractionEnabled = true
        ellipseF.addGestureRecognizer(ellipseFTap)
    }
    
    @objc private func ellipseMButtonAction(_ sender: UITapGestureRecognizer) {
        self.ellipseM.image = UIImage(named: "ellipseTrue")
        self.ellipseF.image = UIImage(named: "ellipseFalse")
    }
    
    @objc private func ellipseFButtonAction(_ sender: UITapGestureRecognizer) {
        self.ellipseF.image = UIImage(named: "ellipseTrue")
        self.ellipseM.image = UIImage(named: "ellipseFalse")
    }
    
    @objc private func rightButtonAction(_ sender: UITapGestureRecognizer) {
        print("rightTap")
        
        let alertController = UIAlertController(title: ProfileConstans.saveAlertTitle, message: ProfileConstans.saveAlerDescription, preferredStyle: .actionSheet)
        let firstAction = UIAlertAction(title: ProfileConstans.saveAlertYesButton, style: .default) { _ in
            print("YES")
            
            if self.nameTextField.text?.isValidId == false {
                self.nameTextField.layer.borderColor = UIColor.red.cgColor
            } else if self.surnameTextField.text?.isValidId == false {
                self.surnameTextField.layer.borderColor = UIColor.red.cgColor
            } else if self.cityTextField.text?.isValidId == false {
                self.cityTextField.layer.borderColor = UIColor.red.cgColor
            } else {
                let realm = try! Realm()
                try! realm.write { ()
                    self.findUser().name = self.nameTextField.text ?? ""
                    self.findUser().surname = self.surnameTextField.text ?? ""
                    self.findUser().birthday = self.birthdayTextField.text ?? ""
                    self.findUser().city = self.cityTextField.text ?? ""
                }
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshTable"), object: nil)
                
                let tr = CATransition()
                tr.duration = 0.25
                tr.type = CATransitionType.reveal
                tr.subtype = CATransitionSubtype.fromLeft
                self.view.window!.layer.add(tr, forKey: kCATransition)
                self.dismiss(animated: false)
            }
        }
        let secondAction = UIAlertAction(title: ProfileConstans.saveAlertNoButton, style: .destructive) { _ in
            print("NOPE")
        }
        
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        self.present(alertController, animated: true)
    }
    
    @objc private func leftButtonAction(_ sender: UITapGestureRecognizer) {
        let tr = CATransition()
        tr.duration = 0.25
        tr.type = CATransitionType.reveal
        tr.subtype = CATransitionSubtype.fromLeft
        view.window!.layer.add(tr, forKey: kCATransition)
        dismiss(animated: false)
        print("leftTap")
    }
}
