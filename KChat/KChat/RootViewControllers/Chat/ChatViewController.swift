//
//  ChatViewController.swift
//  KChat
//
//  Created by Sokolov on 03.04.2023.
//

import UIKit
import RealmSwift
import KeychainSwift

class ChatViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "ChatViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        navigationItem.title = "chat".localized
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupView() {
        view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        return realm.objects(MemberModel.self).count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatViewCell", for: indexPath) as! ChatTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let realm = try! Realm()
        let keychain = KeychainSwift()
        func setupMessage() -> String{
            if realm.objects(MemberModel.self)[indexPath.row].id == keychain.get("id") {
                return "Notes"
            } else {
                return "Mew mew mew mew mew mew mew mew mew mew mew mew mew mew mew!"
            }
        }
        cell.setup(user: realm.objects(MemberModel.self)[indexPath.row],  message: setupMessage())
        return cell
    }
}
