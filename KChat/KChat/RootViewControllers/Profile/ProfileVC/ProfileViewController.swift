//
//  ProfileViewController.swift
//  KChat
//
//  Created by Sokolov on 27.03.2023.
//

import UIKit
import RealmSwift
import KeychainSwift

final class ProfileViewController: UIViewController {

    private let user: MemberModel
    private let realmService: RealmService
    private let keychain: KeychainSwift

    init(user: MemberModel, realmService: RealmService, keychain: KeychainSwift) {
        self.user = user
        self.realmService = realmService
        self.keychain = keychain
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var postIdForComments = ""
    var myPosts = [PostModel]()
    
    enum Status {
        case set
        case save
    }
    
    enum Liked {
        case liked
        case notLiked
    }
    
    enum Favorite {
        case toFavorite
        case deleteFavorite
    }
    
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
        self.tabBarController?.tabBar.isHidden = false
        self.hideKeyboardWhenTappedAround()
        
        setupNavigationBar()
        setupView()
        setupPostsArray()

        NotificationCenter.default.addObserver(self, selector: #selector(refreshUserSettings), name: NSNotification.Name(rawValue: "refreshUserSettings"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPosts), name: NSNotification.Name(rawValue: "refreshPosts"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTable), name: NSNotification.Name(rawValue: "refreshTable"), object: nil)

    }
    
    private func setupNavigationBar() {
        let idLabel = UILabel()
        idLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 24)
        idLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        idLabel.textColor = .black
        idLabel.text = self.findUser().id
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
        let realm = try! Realm()
        let userPosts = realm.objects(PostModel.self).where {
            $0.userID == self.findUser().id
        }
        userPosts.forEach { post in
            myPosts.append(post)
        }
    }
    
    @objc func settingsButtonAction() {
        let vc = SettingsViewController(realmService: realmService)
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
        self.tableView.reloadData()
    }
    
    @objc func refreshPosts() {
        tableView.performBatchUpdates {
            setupPostsArray()
            self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
        }
    }
    
    @objc func refreshUserSettings() {
        tableView.performBatchUpdates {
            setupPostsArray()
            self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
}
extension ProfileViewController: PostTableViewCellProtocol, PostsHeaderProtocol, ProfileHeaderProtol {

    func status(text: String, setupStatusBool: Bool, completion: @escaping (Status) -> Void) {
        var status: Status
        let updates: () -> Void
        if setupStatusBool == false {
            status = .set
            updates = {
            }
        } else {
            status = .save
            updates = {
                let realm = try! Realm()
                try! realm.write { ()
                    self.findUser().status = text
                }
                self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
            }
        }
        self.tableView.performBatchUpdates(updates) { _ in
            completion(status)
        }
    }
    
    func tapFavoriteButton(userId: String, postId: String, postImage: String, postText: String, postLike: Int, postComments: Int, likeBool: Bool, favoriteBool: Bool, indexOfRow: Int, completion: @escaping (ProfileViewController.Favorite) -> Void) {
        let favorite: Favorite
        let updates: () -> Void
        let bool = favoriteBool
        if bool == false {
            favorite = .toFavorite
                updates = {
                    let realm = try! Realm()
                    let user = realm.objects(MemberModel.self).where {
                        $0.id == userId
                    }
                    if realm.objects(FavoritePostModel.self).count < 1 {
                        self.realmService.addFavoritePost(userAvatar: user.first!.avatar, userId: user.first!.id, postId: postId, postImage: postImage, postText: postText, postLike: postLike, postComments: postComments, likeBool: likeBool)
                    } else {
                        if let _ = realm.objects(FavoritePostModel.self).first(where: { $0.postId != postId}) {
                            self.realmService.addFavoritePost(userAvatar: user.first!.avatar, userId: user.first!.id, postId: postId, postImage: postImage, postText: postText, postLike: postLike, postComments: postComments, likeBool: likeBool)
                        }
                    }
                    let indexPath = IndexPath(item: indexOfRow, section: 1)
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            } else {
                favorite = .deleteFavorite
                updates = {
                    let realm = try! Realm()
                    try! realm.write { ()
                        if let post = realm.objects(FavoritePostModel.self).first(where: { $0.postId == postId}) {
                            realm.delete(post)
                        }
                    }
                    let indexPath = IndexPath(item: indexOfRow, section: 1)
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        self.tableView.performBatchUpdates(updates) { _ in
            completion(favorite)
        }
    }
    
    func tapLikeButton(id: String, likedBool: Bool, indexOfRow: Int, completion: @escaping (ProfileViewController.Liked) -> Void) {
        let liked: Liked
        let updates: () -> Void
        let bool = likedBool
        if bool == false {
                liked = .liked
                updates = {
                    let realm = try! Realm()
                    try! realm.write { ()
                        if let post = realm.objects(PostModel.self).first(where: { $0.postId == id}) {
                            post.likes += 1
                            post.likedBool = true
                        }
                    }
                    let indexPath = IndexPath(item: indexOfRow, section: 1)
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            } else {
                liked = .notLiked
                updates = {
                    let realm = try! Realm()
                    try! realm.write { ()
                        if let post = realm.objects(PostModel.self).first(where: { $0.postId == id}) {
                            post.likes -= 1
                            post.likedBool = false
                        }
                    }
                    let indexPath = IndexPath(item: indexOfRow, section: 1)
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        self.tableView.performBatchUpdates(updates) { _ in
            completion(liked)
        }
    }
    
    func openComments() {
        let vc = CommentViewController(realmService: realmService)
        vc.postID = self.postIdForComments
        print(vc.postID)
        self.present(vc, animated: true)
    }
    
    func takePostId(id: String) {
        self.postIdForComments = id
    }

    
    func createPost() {
        let vc = CreatePostViewController(realmService: realmService, keychain: keychain)
        self.present(vc, animated: true)
    }
    
    func getCommentsCount(id: String) -> Int {
        let realm = try! Realm()
        let comment = realm.objects(CommentsModel.self).where {
            $0.postId == id
        }
        return comment.count
    }
    
    func checkFavorite(id: String) -> Bool {
        let realm = try! Realm()
        if let _ = realm.objects(FavoritePostModel.self).first(where: { $0.postId == id}) {
            return true
        } else {
            return false
        }
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
            let realm = try! Realm()
            var photosArray = [String]()
            realm.objects(PhotoModel.self).forEach { photo in
                photosArray.insert(photo.photo, at: 0)
            }
            cell.setupArray(array: photosArray)
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostViewCell", for: indexPath) as! PostTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.setup(with: myPosts.reversed()[indexPath.row])
            cell.changeAvatarAndId(avatar: UIImage(data: self.findUser().avatar)!, id: self.findUser().id)
            let getRow = self.tableView.indexPath(for: cell)
            cell.getRow(indexOfRow: getRow?.row ?? 0)
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
            let vc = PhotosViewController(realmService: realmService)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header =  tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableHeader") as! ProfileHeaderViewTable
            header.setup(with: self.findUser())
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 170
        } else {
            return 38
        }
    }
}


