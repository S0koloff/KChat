//
//  MainViewController.swift
//  KChat
//
//  Created by Sokolov on 04.04.2023.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, HistoryTableViewProtocol, HistoryProtocol, MainPostTableViewCellProtocol {
    
    let realm = try! Realm()
    var postIdForComments = ""
    var postsArray = [PostModel]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostsTableViewCell.self, forCellReuseIdentifier: "PostsViewCell")
        tableView.register(HistoryTableViewCell.self, forHeaderFooterViewReuseIdentifier: "HistoryViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        self.tabBarController?.tabBar.isHidden = false
        navigationItem.title = "main".localized
        setupPostsArray()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
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
    
    private func setupPostsArray() {
        let posts = realm.objects(PostModel.self).where {
            $0.userID != UserDefaultSettings.userModel.id
        }
        
        posts.forEach { post in
            postsArray.append(post)
        }
    }
    
    func openHistorySecondStep(ownerId: String) {
        let historyVC = HistoryVC()
        
        let ownerHistory = realm.objects(HistoryPostModel.self).where {
            $0.userId == ownerId
        }
        
        guard let history = ownerHistory.first else {
            return
        }
        historyVC.setup(with: history)
        historyVC.historyDelelgate = self
        historyVC.setupGesture()
        historyVC.modalPresentationStyle = .fullScreen
        self.present(historyVC, animated: true)
    }
    
    func openMemberProfile(profileID: String) {
        let memberProfileVC = MemberProfileVC()
        navigationController?.pushViewController(memberProfileVC, animated: true)
    }
    
    @objc func refreshTable() {
        setupPostsArray()
        tableView.reloadData()
    }
    
    func openComments() {
        let vc = CommentViewController()
        vc.postID = self.postIdForComments
        print(vc.postID)
        self.present(vc, animated: true)
    }
    
    func takePostId(id: String) {
        self.postIdForComments = id
    }
    
    func tapToLike() {
        tableView.reloadData()
    }
    

}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 700
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsViewCell", for: indexPath) as! PostsTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
                
        cell.setup(with: realm.objects(PostModel.self)[indexPath.row])
        cell.changeAvatarAndId(user: realm.objects(MemberModel.self)[indexPath.row], post: realm.objects(PostModel.self)[indexPath.row])
        print(realm.objects(MemberModel.self)[indexPath.row])
        print(realm.objects(PostModel.self)[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let header =  tableView.dequeueReusableHeaderFooterView(withIdentifier: "HistoryViewCell") as! HistoryTableViewCell
            header.historyTableVCDelegate = self
            return header

    }
}

