//
//  OverviewViewController.swift
//  Locus
//
//  Created by Xie kesong on 4/25/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let recentlyVisitedSpotReuseIden = "RecentlyVisitedCollectionViewCell"
fileprivate let recentlyVisitedSpotNibName = "RecentlyVisitedCollectionViewCell"

fileprivate let popularSpotReuseIden = "PopularSpotCollectionViewCellIden"
fileprivate let popularSpotNibName = "PopularSpotCollectionViewCell"

fileprivate let popularTuneSpotTitle = "Popular Nearby Spots"
fileprivate let recentlyVisitedSpotTitle = "Recently Visited Spots"


fileprivate let spotThumbnailReuseIden = "SpotThumbnailReuseIden"
fileprivate let spotThumbnailNibName = "SpotThumbnailCollectionViewCell"


fileprivate struct CollectionViewUI{
    static let UIEdgeSpace: CGFloat = 16.0
    static let MinmumLineSpace: CGFloat = 16.0
    static let MinmumInteritemSpace: CGFloat = 16.0
}


class OverviewViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.alwaysBounceVertical = true
            self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0)
            self.collectionView.refreshControl = self.refreshControl
            
            //register for recently visited spot cell and reuse
            self.collectionView.register(UINib(nibName: recentlyVisitedSpotNibName, bundle: nil), forCellWithReuseIdentifier: recentlyVisitedSpotReuseIden)
            
            //register for smart genre cell and reuse
//            self.collectionView.register(UINib(nibName: popularSpotNibName, bundle: nil), forCellWithReuseIdentifier: popularSpotReuseIden)
            
            self.collectionView.register(UINib(nibName: spotThumbnailNibName, bundle: nil), forCellWithReuseIdentifier: spotThumbnailReuseIden)


            //reuse header
            self.collectionView.register(UINib(nibName: CollectionHeaderReusableViewNibName, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: collectionHeaderReusableViewIden)
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl =  UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshDragged(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    
    var shouldShowRecentlyVisistedSection = false{
        didSet{
            self.reloadData()
        }
    }
    
    var recentlyVisitedSpot: [TuneSpot]?
    
    var popularSpot: [TuneSpot]?{
        didSet{
            self.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(popularSpotShouldUpdate(_:)), name: App.LocalNotification.Name.popularSpotShouldUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recentlyVisitedShouldUpdate(_:)), name: App.LocalNotification.Name.recentlyVisitedShouldUpdate, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func popularSpotShouldUpdate(_ notification: Notification){
        self.reloadData()
    }
    
    func recentlyVisitedShouldUpdate(_ notification: Notification){
        self.shouldShowRecentlyVisistedSection = true
        self.collectionView.reloadData()
    }
    
    
    func refreshDragged(_ refreshControl: UIRefreshControl){
        TuneSpot.getNearbyPopularTuneSpot { (spots) in
            if let spots = spots{
                App.delegate?.popularTuneSpot = spots
            }
        }
    }
    
    func reloadData(){
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.collectionView.reloadData()
        }
    }
}





extension OverviewViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.shouldShowRecentlyVisistedSection ? 2 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.shouldShowRecentlyVisistedSection{
            if section == 0{
                //return the number of recently visited spot
                return 1
            }
        }
        return App.delegate?.popularTuneSpot?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.shouldShowRecentlyVisistedSection{
            if indexPath.section == 0{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recentlyVisitedSpotReuseIden, for: indexPath) as! RecentlyVisitedCollectionViewCell
                cell.delegate = self
                cell.spots = User.current()?.recentlyVisitedSpot?.spots
                return cell
            }
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: spotThumbnailReuseIden, for: indexPath) as! SpotThumbnailCollectionViewCell
        cell.delegate = self
        cell.spot = App.delegate?.popularTuneSpot?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: collectionHeaderReusableViewIden, for: indexPath) as! CollectionHeaderReusableView
        if self.shouldShowRecentlyVisistedSection{
            if indexPath.section == 0{
                headerView.title = recentlyVisitedSpotTitle
            }else{
                headerView.title = popularTuneSpotTitle
            }
        }else{
            headerView.title = popularTuneSpotTitle
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: App.screenWidth, height: 54.0)
    }
    
}


extension OverviewViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.shouldShowRecentlyVisistedSection{
            if indexPath.section == 0{
                return CGSize(width:App.screenWidth, height: 148)
            }
        }
        let length = (self.view.frame.size.width - 2 * CollectionViewUI.UIEdgeSpace - CollectionViewUI.MinmumInteritemSpace) / 2 ;
        return CGSize(width: length, height: length + 60)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if self.shouldShowRecentlyVisistedSection{
            if section == 0{
                return 0
            }
        }
        return CollectionViewUI.MinmumLineSpace
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if self.shouldShowRecentlyVisistedSection{
            if section == 0{
             return  UIEdgeInsets(top: 0, left: 0, bottom: CollectionViewUI.UIEdgeSpace, right: 0)
            }
        }
        return  UIEdgeInsetsMake( 0,  CollectionViewUI.UIEdgeSpace,  0,  CollectionViewUI.UIEdgeSpace)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if self.shouldShowRecentlyVisistedSection{
            if section == 0{
                return 0
            }
        }
        return CollectionViewUI.MinmumInteritemSpace
    }
}


extension OverviewViewController: RecentlyVisitedCollectionViewCellDelegate, SpotThumbnailCollectionViewCellDelegate{
    func spotThumbnailImageViewImageTapped(spot: TuneSpot) {
        if let spotVC = App.spotStoryBoard.instantiateViewController(withIdentifier: App.SpotStoryboardIden.spotViewController) as? SpotViewController{
            spotVC.spot = spot
            self.navigationController?.pushViewController(spotVC, animated: true)
        }
    }
}



