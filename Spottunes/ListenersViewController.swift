//
//  ListenersViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 5/7/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

//
//  OverviewViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 4/25/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let onlineListenersCollectionViewCellIden = "OnlineListenersCollectionViewCell"
fileprivate let onlineListenersCollectionViewCellNibName = "OnlineListenersCollectionViewCell"



fileprivate struct CollectionViewUI{
    static let UIEdgeSpace: CGFloat = 16.0
    static let MinmumLineSpace: CGFloat = 16.0
    static let MinmumInteritemSpace: CGFloat = 16.0
}


class ListenersViewController: UIViewController {
    
    var flowLayout: UICollectionViewFlowLayout!{
        return self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.alwaysBounceVertical = true
            self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0)
            
            //register for recommendation spot cell and reuse
            self.collectionView.register(UINib(nibName: onlineListenersCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: onlineListenersCollectionViewCellIden)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.flowLayout.estimatedItemSize = CGSize(width: App.screenWidth, height: 80)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}




extension ListenersViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return section == 0 ? 1 : (self.genre?.count ?? 0)
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: onlineListenersCollectionViewCellIden, for: indexPath) as! OnlineListenersCollectionViewCell
        
        return cell
    }

//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: collectionHeaderReusableViewIden, for: indexPath) as! CollectionHeaderReusableView
//        if indexPath.section == 0 {
//            headerView.title = "Popular Tunes Spots"
//        }else if indexPath.section == 1 {
//            headerView.title = "Smart Genres"
//        }
//        return headerView
//    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: App.screenWidth, height: 54.0)
//    }
//
}

extension ListenersViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            return CGSize(width:App.screenWidth, height: 100)
        }else{
            let length = (self.view.frame.size.width - 2 * CollectionViewUI.UIEdgeSpace - CollectionViewUI.MinmumInteritemSpace) / 2 ;
            return CGSize(width: length, height: length + 38)
        }
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return section == 0 ? 0 :  CollectionViewUI.MinmumLineSpace
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return  section == 0 ? UIEdgeInsets(top: 0, left: 0, bottom: CollectionViewUI.UIEdgeSpace, right: 0) : UIEdgeInsetsMake( 0,  CollectionViewUI.UIEdgeSpace,  0,  CollectionViewUI.UIEdgeSpace)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return section == 0 ? 0 : CollectionViewUI.MinmumInteritemSpace
//    }
}


