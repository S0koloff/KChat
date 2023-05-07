//
//  MemberProfileVC.swift
//  KChat
//
//  Created by Sokolov on 12.04.2023.
//

import UIKit
import RealmSwift

class MemberProfileVC: UIViewController {
    
    let realm = try! Realm()
    
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
    }
    
    private func setupNavigationBar() {
        let idLabel = UILabel()
        idLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 24)
        idLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        idLabel.textColor = .black
        
        
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
    
    func openComments() {
        let vc = CommentViewController()
        self.present(vc, animated: true)
    }
    
}

extension MemberProfileVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == .zero {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MemberPhotosViewCell", for: indexPath) as! MemberPhotosTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MemberPostViewCell", for: indexPath) as! MemberPostTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
//            cell.setup(with: post[indexPath.row])
//            cell.changeAvatarAndId(avatar: profileData.avatar, id: profileData.id)
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
            let header =  tableView.dequeueReusableHeaderFooterView(withIdentifier: "MemberTableHeader") as! MemberProfileHeaderViewTable
//            header.setup(with: profileData)
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
}
