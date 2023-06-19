//
//  CommentViewController.swift
//  KChat
//
//  Created by Sokolov on 07.04.2023.
//

import UIKit
import RealmSwift
import KeychainSwift

class CommentViewController: UIViewController {
    
    private let realmService: RealmService
    
    init(realmService: RealmService) {
        self.realmService = realmService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var postID = ""
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CommentsViewCell.self, forCellReuseIdentifier: "Comments")
        tableView.register(CommentsHeaderView.self, forHeaderFooterViewReuseIdentifier: "Header")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var commentTextField: UITextField = {
        let commentTextField = UITextField()
        commentTextField.font = .systemFont(ofSize: 16, weight: .regular)
        commentTextField.textColor = .black
        commentTextField.autocapitalizationType = .none
        commentTextField.layer.borderWidth = 0.8
        commentTextField.layer.borderColor = Colors.gray.cgColor
        commentTextField.layer.cornerRadius = 10
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        commentTextField.leftViewMode = .always
        commentTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: commentTextField.frame.height))
        return commentTextField
    }()
    
    private lazy var addComment: UIImageView = {
        let addComment = UIImageView()
        addComment.contentMode = .scaleAspectFill
        addComment.image = UIImage(systemName: "arrow.up.circle")
        addComment.tintColor = .black
        addComment.translatesAutoresizingMaskIntoConstraints = false
        return addComment
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(commentTextField)
        view.addSubview(addComment)
        
        setupConstraints()
        setupGesture()
        self.hideKeyboardWhenTappedAround()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
        
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: commentTextField.topAnchor, constant: -5),
            
            commentTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 22),
            commentTextField.rightAnchor.constraint(equalTo: addComment.leftAnchor, constant: -6),
            commentTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -18),
            commentTextField.heightAnchor.constraint(equalToConstant: 35),
            
            addComment.centerYAnchor.constraint(equalTo: commentTextField.centerYAnchor),
            addComment.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -22),
            addComment.widthAnchor.constraint(equalToConstant: 30),
            addComment.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        updateArray()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    
    private func updateArray() {
        tableView.reloadData()
    }
    
    private func setupGesture() {
        let addCommentTap = UITapGestureRecognizer(target: self, action: #selector(self.addCommentAction(_:)))
        addComment.isUserInteractionEnabled = true
        addComment.addGestureRecognizer(addCommentTap)
    }
    
    func tapToLike() {
        tableView.reloadData()
    }
    
    func getCommentsCount(id: String) -> Int {
        let realm = try! Realm()
        let comment = realm.objects(CommentsModel.self).where {
            $0.postId == id
        }
        return comment.count
    }
    
    @objc private func addCommentAction(_ sender: UITapGestureRecognizer) {
        realmService.createComment(postId: postID,
                                   avatar: self.findUser().avatar,
                                   text: commentTextField.text ?? "",
                                   date: "22.02",
                                   likes: 0,
                                   userId: self.findUser().id)
        self.commentTextField.text = ""
        print("commentADD")
        updateArray()
    }
    
    
    @objc func refreshTable() {
        tableView.reloadData()
    }
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }

    @objc func keyboardWillChange(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if commentTextField.isFirstResponder {
                self.view.frame.origin.y = -keyboardSize.height
            }
        }
    }
}

extension CommentViewController: CommentsHeaderProtocol {
    
    func tapToLikeTrue(id: String) {
        let realm = try! Realm()
        try! realm.write { ()
            if let post = realm.objects(PostModel.self).first(where: { $0.postId == id}) {
                post.likes += 1
                post.likedBool = true
            }
        }
        tableView.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshPosts"), object: nil)
    }
    
    func tapToLikeFalse(id: String) {
        let realm = try! Realm()
        try! realm.write { ()
            if let post = realm.objects(PostModel.self).first(where: { $0.postId == id}) {
                post.likes -= 1
                post.likedBool = false
            }
        }
        tableView.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshPosts"), object: nil)
    }
}

extension CommentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        let comments = realm.objects(CommentsModel.self).where {
                $0.postId == self.postID
            }
        print("ARRAYCOUNT:", comments.count)
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Comments", for: indexPath) as! CommentsViewCell
        let realm = try! Realm()
        let comments = realm.objects(CommentsModel.self).where {
                $0.postId == self.postID
            }
        cell.setup(with: comments[indexPath.item])
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 700
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header =  tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as! CommentsHeaderView
            
            let realm = try! Realm()
            try! realm.write { ()
                if let post = realm.objects(PostModel.self).first(where: { $0.postId == self.postID}) {
                    
                    let user = realm.objects(MemberModel.self).where {
                        $0.id == post.userID
                    }
                    
                    header.setup(with: post)
                    header.changeAvatarAndId(user: user.first!)
                }
            }
            header.delegate = self
            return header
        } else {
            return nil
        }
    }
    
}

