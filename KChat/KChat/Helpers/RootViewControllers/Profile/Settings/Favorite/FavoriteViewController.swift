//
//  FavoriteViewController.swift
//  KChat
//
//  Created by Sokolov on 05.04.2023.
//

import UIKit
import RealmSwift

class FavoriteViewController: UIViewController, FavoriteCellProtocol {
    
    let migrationBlock: MigrationBlock = { migration, oldSchemaVersion in
    }
    lazy var realm: Realm = {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 1, migrationBlock: migrationBlock)
        return try! Realm()
    }()
    
    
    private lazy var infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        infoLabel.textColor = .black
        infoLabel.text = ProfileConstans.favoritesTitle
        return infoLabel
    }()
    
    private lazy var leftButton: UIImageView = {
        let leftButton = UIImageView()
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.contentMode = .scaleAspectFit
        leftButton.image = UIImage(named: "cancelButton")
        return leftButton
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: "FavoriteViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(self.infoLabel)
        view.addSubview(self.leftButton)
        view.addSubview(self.tableView)
        
        setupConstraints()
        setupGesture()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTable), name: NSNotification.Name(rawValue: "favoritesUpdate"), object: nil)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
        
            self.infoLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            self.infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            self.leftButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
            self.leftButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            self.leftButton.widthAnchor.constraint(equalToConstant: 25),
            self.leftButton.heightAnchor.constraint(equalToConstant: 25),
        
            self.tableView.topAnchor.constraint(equalTo: leftButton.bottomAnchor, constant: 5),
            self.tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupGesture() {
        let leftTap = UITapGestureRecognizer(target: self, action: #selector(self.leftButtonAction(_:)))
        leftButton.isUserInteractionEnabled = true
        leftButton.addGestureRecognizer(leftTap)
    }
    
    @objc private func leftButtonAction(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "settingsUpdate"), object: nil)
        let tr = CATransition()
            tr.duration = 0.25
        tr.type = CATransitionType.reveal
        tr.subtype = CATransitionSubtype.fromLeft
            view.window!.layer.add(tr, forKey: kCATransition)
        dismiss(animated: false)
    }
    
    func refreshFavorites() {
        tableView.reloadData()
    }
    
    @objc func refreshTable() {
        tableView.reloadData()
    }
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.objects(FavoritePostModel.self).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteViewCell", for: indexPath) as! FavoriteTableViewCell
        cell.setup(with: realm.objects(FavoritePostModel.self).reversed()[indexPath.row])
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.delegate = self
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 700
    }
    
    
}



