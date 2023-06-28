//
//  MemberProfileVC.swift
//  KChat
//
//  Created by Sokolov on 12.04.2023.
//

import UIKit
import RealmSwift

class MemberProfileVC: UIViewController {
    
    private let realmService: RealmService
    
    init(realmService: RealmService) {
        self.realmService = realmService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var profileID = ""
    var postIdForComments = ""
    
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
        tableView.register(MemberProfileHeaderViewTable.self, forHeaderFooterViewReuseIdentifier: "MemberTableHeader")
        tableView.register(MemberPhotosTableViewCell.self, forCellReuseIdentifier: "MemberPhotosViewCell")
        tableView.register(MemberPostsHeaderCell.self, forHeaderFooterViewReuseIdentifier: "MemberPostsHeader")
        tableView.register(MemberPostTableViewCell.self, forCellReuseIdentifier: "MemberPostViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupView()
        self.tabBarController?.tabBar.isHidden = false
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPosts), name: NSNotification.Name(rawValue: "refreshPosts"), object: nil)
    }
    
    private func setupNavigationBar() {
        let idLabel = UILabel()
        idLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 24)
        idLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        idLabel.textColor = .black
        idLabel.text = profileID
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: idLabel)
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
    
    @objc func refreshPosts() {
        tableView.performBatchUpdates {
            self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
        }
    }
    
}

extension MemberProfileVC: MemberPostTableViewCellProtocol {
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
    
    func tapLikeButton(id: String, likedBool: Bool, indexOfRow: Int, completion: @escaping (Liked) -> Void) {
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
    
    func tapFavoriteButton(userId: String, postId: String, postImage: String, postText: String, postLike: Int, postComments: Int, likeBool: Bool, favoriteBool: Bool, indexOfRow: Int, completion: @escaping (Favorite) -> Void) {
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
    
    func openComments() {
        let vc = CommentViewController(realmService: realmService)
        vc.postID = self.postIdForComments
        self.present(vc, animated: true)
    }
    
    
}

extension MemberProfileVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        let realm = try! Realm()
        let posts = realm.objects(PostModel.self).where { post in
            post.userID == profileID
        }
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == .zero {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MemberPhotosViewCell", for: indexPath) as! MemberPhotosTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MemberPostViewCell", for: indexPath) as! MemberPostTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            let realm = try! Realm()
            let posts = realm.objects(PostModel.self).where { post in
                post.userID == profileID
            }
            let member = realm.objects(MemberModel.self).where { member in
                member.id == profileID
            }
            cell.setup(with: posts[indexPath.row])
            cell.changeAvatarAndId(avatar: UIImage(data: member.first!.avatar)!, id: member.first!.id)
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
            let header =  tableView.dequeueReusableHeaderFooterView(withIdentifier: "MemberTableHeader") as! MemberProfileHeaderViewTable
            let realm = try! Realm()
            let member = realm.objects(MemberModel.self).where { member in
                member.id == profileID
            }
            header.setup(with: member.first!)
            return header
        } else {
            if section == 1 {
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MemberPostsHeader") as! MemberPostsHeaderCell
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
