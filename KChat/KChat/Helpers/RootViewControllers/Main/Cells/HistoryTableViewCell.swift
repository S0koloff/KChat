//
//  HistoryTableViewCell.swift
//  KChat
//
//  Created by Sokolov on 04.04.2023.
//

import UIKit
import RealmSwift

protocol HistoryTableViewProtocol {
    func openHistorySecondStep(ownerId: String)
}

class HistoryTableViewCell: UITableViewHeaderFooterView, HistoryCollectionViewCellProtocol {
    
    var historyTableVCDelegate: HistoryTableViewProtocol?
    
    let realm = try! Realm()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.register(HistoryCollectionViewCell.self, forCellWithReuseIdentifier: "HistoryCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupView()
        print("ON MAIN HISTORY TABLEVIEW CELL", realm.objects(HistoryPostModel.self).count)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
    
        self.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            
            self.collectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
            self.collectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -7),
            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.collectionView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func openHistoryFirstStep(ownerId: String) {
            let profile = realm.objects(HistoryPostModel.self).where {
                $0.userId == ownerId
        }
        historyTableVCDelegate?.openHistorySecondStep(ownerId: profile.first?.userId ?? "")
    }
    

}

extension HistoryTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realm.objects(HistoryPostModel.self).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCell", for: indexPath) as! HistoryCollectionViewCell
        cell.setup(historyPost: realm.objects(HistoryPostModel.self)[indexPath.row])
        cell.layer.borderWidth = 1.5
        cell.layer.borderColor = Colors.orange.cgColor
        cell.layer.cornerRadius = cell.frame.height / 2
        cell.delegateHistory = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 75)
    }
}
