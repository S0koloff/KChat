//
//  ProfileViewController.swift
//  KChat
//
//  Created by Sokolov on 27.03.2023.
//

import UIKit
import RealmSwift

class ProfileViewController: UIViewController, PostTableViewCellProtocol, PostsHeaderProtocol, ProfileHeaderProtol {

    let realm = try! Realm()
    
    var postIdForComments = ""
    
    var myPosts = [PostModel]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileHeaderViewTable.self, forHeaderFooterViewReuseIdentifier: "TableHeader")
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostViewCell")
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotosViewCell")
        tableView.register(PostsHeaderCell.self, forHeaderFooterViewReuseIdentifier: "PostsHeader")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupView()
        setupPostsArray()
        self.tabBarController?.tabBar.isHidden = false
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTable), name: NSNotification.Name(rawValue: "settingsUpdate"), object: nil)
    }
    
    private func setupNavigationBar() {
        let idLabel = UILabel()
        idLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 24)
        idLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        idLabel.textColor = .black
        idLabel.text = UserDefaultSettings.userModel.id
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: idLabel)
        
        let rightButton = UIButton(type: .system)
        rightButton.setImage(UIImage(named: "lines")?.withRenderingMode(.alwaysOriginal), for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        rightButton.tintColor = Colors.orange
        rightButton.imageView?.contentMode = .scaleAspectFit
        rightButton.addTarget(self, action: #selector(self.settingsButtonAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    private func setupView() {
        self.view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
        
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 65),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        
        ])
    }
    
    func setupPostsArray() {
        let userPosts = realm.objects(PostModel.self).where {
            $0.userID == UserDefaultSettings.userModel.id
        }
        userPosts.forEach { post in
            myPosts.append(post)
        }
    }
    
    @objc func settingsButtonAction() {
        let vc = SettingsViewController()
        let tr = CATransition()
        tr.duration = 0.25
        tr.type = CATransitionType.moveIn
        tr.subtype = CATransitionSubtype.fromRight
        view.window!.layer.add(tr, forKey: kCATransition)
        view.frame.origin.y = view.frame.width - 150
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
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
    
    func createPost() {
        let vc = CreatePostViewController()
        self.present(vc, animated: true)
    }
    
    func statusUpdate(text: String) {
        
        let updateUserData = UserModel(id: UserDefaultSettings.userModel.id,
                                       avatar: UserDefaultSettings.userModel.avatar,
                                       name: UserDefaultSettings.userModel.name,
                                       surname: UserDefaultSettings.userModel.surname,
                                       status: text,
                                       birthday: UserDefaultSettings.userModel.birthday,
                                       city: UserDefaultSettings.userModel.city)
        
        UserDefaultSettings.userModel = updateUserData
        tableView.reloadData()
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return myPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == .zero {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosViewCell", for: indexPath) as! PhotosTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostViewCell", for: indexPath) as! PostTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.setup(with: myPosts.reversed()[indexPath.row])
            cell.changeAvatarAndId(avatar: UserDefaultSettings.userModel.avatar, id: UserDefaultSettings.userModel.id)
            cell.delegate = self
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == .zero {
            return 150
        } else {
            return 700
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = PhotosViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header =  tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableHeader") as! ProfileHeaderViewTable
            header.setup(with: UserDefaultSettings.userModel)
            header.delegate = self
            return header
        } else {
            if section == 1 {
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PostsHeader") as! PostsHeaderCell
                header.delegate = self
                return header
            } else {
                return nil
            }
        }
    }
    
}


