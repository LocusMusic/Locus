//
//  OverviewViewController.swift
//  Spottunes
//
//  Created by Xie kesong on 4/25/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let recommendedSpotReuseIden = "RecommendedSpotReuseIden"
fileprivate let recommendedSpotNibName = "RecommendationSpotCollectionViewCell"

fileprivate let collectionHeaderReusableViewIden = "CollectionHeaderReusableView"
fileprivate let CollectionHeaderReusableViewNibName = "CollectionHeaderReusableView"

fileprivate let smartGenreReuseIden = "SmartGenreReuseIden"
fileprivate let smartGenreNibName = "SmartGenreCollectionViewCell"

fileprivate let smartGenreReusableReuseIden = "RecommendationSpotCollectionReusableView"
fileprivate let smartGenreReusableNibName = "RecommendationSpotCollectionReusableView"

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
            
            self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 16, 0)
            
            //register for recommendation spot cell and reuse
            self.collectionView.register(UINib(nibName: recommendedSpotNibName, bundle: nil), forCellWithReuseIdentifier: recommendedSpotReuseIden)
            self.collectionView.register(UINib(nibName: CollectionHeaderReusableViewNibName, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: collectionHeaderReusableViewIden)
            
            //register for smart genre cell and reuse
            self.collectionView.register(UINib(nibName: smartGenreNibName, bundle: nil), forCellWithReuseIdentifier: smartGenreReuseIden)

        }
    }
    
    var spot: [Spot]?
    
    var genre: [Genre]?

    override func viewDidLoad() {
        super.viewDidLoad()
        let spot_1 = Spot(name: "Geisel", thubmnailURL: "images-4")
        let spot_2 = Spot(name: "Murray", thubmnailURL: "images-3")
        let spot_3 = Spot(name: "Price Center", thubmnailURL: "images-2")
        let spot_4 = Spot(name: "Sixty Four Degree", thubmnailURL: "images-1")
        let spot_5 = Spot(name: "RIMAC", thubmnailURL: "images-5")
        self.spot = [spot_1, spot_5, spot_3, spot_2, spot_4]
        
        
        let genre_1 = Genre(name: "Rock 80's", thubmnailURL: "images-5")
        let genre_2 = Genre(name: "Focus", thubmnailURL: "images-1")
        let genre_3 = Genre(name: "Chill", thubmnailURL: "images-2")
        let genre_4 = Genre(name: "Romance", thubmnailURL: "images-3")
        let genre_5 = Genre(name: "Mood", thubmnailURL: "images-4")
        self.genre = [genre_2, genre_3, genre_4, genre_5, genre_1]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}




extension OverviewViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : (self.genre?.count ?? 0)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recommendedSpotReuseIden, for: indexPath) as! RecommendationSpotCollectionViewCell
            cell.spot = self.spot
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: smartGenreReuseIden, for: indexPath) as! SmartGenreCollectionViewCell
            cell.genre = self.genre![indexPath.row]
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: collectionHeaderReusableViewIden, for: indexPath) as! CollectionHeaderReusableView
        if indexPath.section == 0 {
            headerView.title = "Popular Tunes Spots"
        }else if indexPath.section == 1 {
            headerView.title = "Smart Genres"
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: App.screenWidth, height: 52.0)
    }
    
}

extension OverviewViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            return CGSize(width:App.screenWidth, height: 128)
        }else{
            let length = (self.view.frame.size.width - 2 * CollectionViewUI.UIEdgeSpace - CollectionViewUI.MinmumInteritemSpace) / 2 ;
            return CGSize(width: length, height: length + 28)
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






