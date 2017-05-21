//
//  ListenerSliderTableViewCell.swift
//  Locus
//
//  Created by Xie kesong on 5/15/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let listenerReuseIden = "ListenerCollectionViewCell"
fileprivate let listenerNibName = "ListenerCollectionViewCell"


class ListenerSliderTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.alwaysBounceHorizontal = true
            self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            self.collectionView.register( UINib(nibName: listenerNibName, bundle: nil), forCellWithReuseIdentifier: listenerReuseIden)
        }
    }
    
    var listeners: [User]?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

extension ListenerSliderTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listeners?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listenerReuseIden, for: indexPath) as! ListenerCollectionViewCell
//        cell.delegate = self
//        cell.user = self.users?[indexPath.row]
        return cell
    }
}

extension ListenerSliderTableViewCell:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let legnth = self.collectionView.frame.size.height
        return CGSize(width: legnth - 48, height: legnth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

