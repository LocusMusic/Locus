//
//  ProfileViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 4/29/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit




fileprivate let profileHeaderReusableViewIden = "ProfileHeaderCollectionViewCell"
fileprivate let profileHeaderNibName = "ProfileHeaderCollectionViewCell"


fileprivate let playlistReusableViewIden = "PlaylistCollectionViewCell"
fileprivate let playlistNibName = "PlaylistCollectionViewCell"

fileprivate let recommendedSpotReuseIden = "RecommendedSpotReuseIden"
fileprivate let recommendedSpotNibName = "RecommendationSpotCollectionViewCell"



fileprivate struct CollectionViewUI{
    static let UIEdgeSpace: CGFloat = 16.0
    static let MinmumLineSpace: CGFloat = 16.0
    static let MinmumInteritemSpace: CGFloat = 16.0
}


class ProfileViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.alwaysBounceVertical = true
        }
    }
    
    
    @IBOutlet weak var navigationHeaderViewWrapper: UIView!{
        didSet{
            let navigationHeaderView = NavigationHeaderView.instanceFromNib(withTitle: "")
            navigationHeaderView.delegate = self
            self.navigationHeaderViewWrapper.addSubview(navigationHeaderView)
        }
    }
    
    var spot: [Spot]?
    var playlists: [Playlist]?{
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SpotifyClient.fetchCurrentUserPlayList { (playlists) in
            if let playlists = playlists{
                self.playlists = playlists
            }
        }
        
         //register profile header
        self.collectionView.register(UINib(nibName: profileHeaderNibName, bundle: nil), forCellWithReuseIdentifier: profileHeaderReusableViewIden)

        //register for listen spot cell and reuse
        self.collectionView.register(UINib(nibName: recommendedSpotNibName, bundle: nil), forCellWithReuseIdentifier: recommendedSpotReuseIden)
        
        //register for collection view header
        self.collectionView.register(UINib(nibName: CollectionHeaderReusableViewNibName, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: collectionHeaderReusableViewIden)
        
        //register for Playlist genre cell and reuse
        self.collectionView.register(UINib(nibName: playlistNibName, bundle: nil), forCellWithReuseIdentifier: playlistReusableViewIden)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemNum: Int = 0
        switch section{
        case 0:
            itemNum =  1
        case 1:
            itemNum = self.playlists?.count ?? 0
        default:
            break
        }
        return itemNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section{
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profileHeaderReusableViewIden, for: indexPath) as! ProfileHeaderCollectionViewCell
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: playlistReusableViewIden, for: indexPath) as! PlaylistCollectionViewCell
            cell.Playlist = self.playlists?[indexPath.row]
            return cell
        }
    }
    
    
    
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        switch section{
//        case 1, 2:
//            return CGSize(width: App.screenWidth, height: 48.0)
//        default:
//            return CGSize(width: 0, height: 0)
//    
//        }
//    }
    
}



extension ProfileViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            return CGSize(width:App.screenWidth, height: App.screenHeight)
        }else {
            let length = (self.view.frame.size.width - 2 * CollectionViewUI.UIEdgeSpace - CollectionViewUI.MinmumInteritemSpace) / 2 ;
            return CGSize(width: length, height: length + 38)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 0 :  CollectionViewUI.MinmumLineSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return  section == 0 ? UIEdgeInsets(top: 0, left: 0, bottom: CollectionViewUI.UIEdgeSpace, right: 0) : UIEdgeInsetsMake( 0,  CollectionViewUI.UIEdgeSpace,  0,  CollectionViewUI.UIEdgeSpace)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 0 : CollectionViewUI.MinmumInteritemSpace
    }
}

extension ProfileViewController: NavigationHeaderViewDelegate{
    func backBtnTapped(header: NavigationHeaderView) {
        self.navigationController?.popViewController(animated: true)
    }
}

