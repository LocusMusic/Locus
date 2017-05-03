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
    var playLists: [Playlist]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        let spot_1 = Spot(name: "Geisel", thubmnailURL: "images-4")
//        let spot_2 = Spot(name: "Murray", thubmnailURL: "images-3")
//        let spot_3 = Spot(name: "Price Center", thubmnailURL: "images-2")
//        let spot_4 = Spot(name: "Sixty Four Degree", thubmnailURL: "images-1")
//        let spot_5 = Spot(name: "RIMAC", thubmnailURL: "images-5")
//        self.spot = [spot_1, spot_5, spot_3, spot_2, spot_4]
//        
//        
//        let playList_1 = Playlist(coverURL: "images-1", name: "EI Ten Eleven", username: "kesongxie")
//        let song_1 = Song(name: "My only swerving", author: "EI Ten Eleven", Playlist: playList_1, hits: 142)
//        playList_1.songs = [song_1]
//        
//        
//        //playerList 2
//        let playList_2 = Playlist(coverURL: "images-2", name: "Superior Focus Tunes", username: "leow")
//        let song_4 = Song(name: "Logic of a dream", author: "Explosion in the Sky", Playlist: playList_2, hits: 100)
//        playList_2.songs = [song_4]
//        
//        
//        //playerList 3
//        let playList_3 = Playlist(coverURL: "images-3", name: "Radio Music Station", username: "edison")
//        
//        let song_7 = Song(name: "Breath and start", author: "Heinali", Playlist: playList_3, hits: 44)
//        playList_3.songs = [song_7]
//        
//        //playerList 4
//        let playList_4 = Playlist(coverURL: "images-4", name: "Nothing Was The Same", username: "edison")
//        let song_9 = Song(name: "Ninth wake", author: "Trifonic", Playlist: playList_4, hits: 36)
//        playList_4.songs = [song_9]
//        
//        //playerList 5
//        let playList_5 = Playlist(coverURL: "images-5", name: "Answer With An Album Cover", username: "leow")
//        let song_11 = Song(name: "Colors in stearo", author: "Com Truise", Playlist: playList_5, hits: 39)
//        playList_5.songs = [song_11]
//        
//        self.playLists = [playList_1, playList_2, playList_3, playList_4, playList_5]
        
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
            itemNum = self.playLists?.count ?? 0
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
            cell.Playlist = self.playLists?[indexPath.row]
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

