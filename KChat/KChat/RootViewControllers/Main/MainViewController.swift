//
//  MainViewController.swift
//  KChat
//
//  Created by Sokolov on 04.04.2023.
//

import UIKit
import RealmSwift
import KeychainSwift

final class MainViewController: UIViewController {
    
    var postIdForComments = ""
    var postsArray = [PostModel]()
    
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
        tableView.register(MainPostsTableViewCell.self, forCellReuseIdentifier: "PostsViewCell")
        tableView.register(HistoryTableViewCell.self, forHeaderFooterViewReuseIdentifier: "HistoryViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = false
        navigationItem.title = "main".localized
        setupView()
        setupPostsArray()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPosts), name: NSNotification.Name(rawValue: "refreshPosts"), object: nil)
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
        let realm = try! Realm()
        let keychain = KeychainSwift()
        let posts = realm.objects(PostModel.self).where {
            $0.userID != keychain.get("id")!
        }
        
        posts.forEach { post in
            postsArray.append(post)
        }
    }
    
    @objc func refreshPosts() {
        tableView.performBatchUpdates {
            self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
}

extension MainViewController: HistoryTableViewProtocol, HistoryProtocol, MainPostTableViewCellProtocol {
 
    func tapFavoriteButton(userId: String, postId: String, postImage: String, postText: String, postLike: Int, postComments: Int, likeBool: Bool, favoriteBool: Bool, indexOfRow: Int, completion: @escaping (MainViewController.Favorite) -> Void) {
        let favorite: Favorite
        let updates: () -> Void
        let bool = favoriteBool
        if bool == false {
            favorite = .toFavorite
                updates = {
                    let realm = try! Realm()
                    let realmService = RealmService()
                    let user = realm.objects(MemberModel.self).where {
                        $0.id == userId
                    }
                    if realm.objects(FavoritePostModel.self).count < 1 {
                        realmService.addFavoritePost(userAvatar: user.first!.avatar, userId: user.first!.id, postId: postId, postImage: postImage, postText: postText, postLike: postLike, postComments: postComments, likeBool: likeBool)
                    } else {
                        if let _ = realm.objects(FavoritePostModel.self).first(where: { $0.postId != postId}) {
                            realmService.addFavoritePost(userAvatar: user.first!.avatar, userId: user.first!.id, postId: postId, postImage: postImage, postText: postText, postLike: postLike, postComments: postComments, likeBool: likeBool)
                        }
                    }
                    let indexPath = IndexPath(item: indexOfRow, section: 0)
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
                    let indexPath = IndexPath(item: indexOfRow, section: 0)
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        self.tableView.performBatchUpdates(updates) { _ in
            completion(favorite)
        }
    }
    
    func tapLikeButton(id: String, likedBool: Bool, indexOfRow: Int, completion: @escaping (MainViewController.Liked) -> Void) {
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
                    let indexPath = IndexPath(item: indexOfRow, section: 0)
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
                    let indexPath = IndexPath(item: indexOfRow, section: 0)
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        self.tableView.performBatchUpdates(updates) { _ in
            completion(liked)
        }
    }
    
    //SETUP HISTORY CELLS
    
    func getHistoryPosts() -> [HistoryPostModel] {
        let realm = try! Realm()
        var historyPostsArray = [HistoryPostModel]()
        realm.objects(HistoryPostModel.self).forEach { post in
            historyPostsArray.append(post)
        }
        return historyPostsArray
    }
    
    func openHistoryFirstStep(ownerId: String) {
        let realm = try! Realm()
        let profile = realm.objects(HistoryPostModel.self).where {
            $0.userId == ownerId
        }
        openHistorySecondStep(ownerId: profile.first?.userId ?? "")
    }
    
    private func openHistorySecondStep(ownerId: String) {
        let historyVC = HistoryVC()
        let realm = try! Realm()
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
    
    //
    
    func openMemberProfile(profileID: String) {
        let memberProfileVC = MemberProfileVC()
        memberProfileVC.profileID = profileID
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

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 700
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsViewCell", for: indexPath) as! MainPostsTableViewCell
        let realm = try! Realm()
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.setup(with: realm.objects(PostModel.self)[indexPath.row])
        var usersArray = [MemberModel]()
        realm.objects(MemberModel.self).forEach { user in
            usersArray.append(user)
        }
        cell.changeAvatarAndId(user: usersArray)
        let getRow = self.tableView.indexPath(for: cell)
        cell.getRow(indexOfRow: getRow?.row ?? 0)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =  tableView.dequeueReusableHeaderFooterView(withIdentifier: "HistoryViewCell") as! HistoryTableViewCell
        header.historyTableVCDelegate = self
        return header
    }
}

