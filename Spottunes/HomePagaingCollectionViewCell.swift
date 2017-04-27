//
//  HomePagaingCollectionViewCell.swift
//  Spottunes
//
//  Created by Xie kesong on 4/25/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

//import UIKit
//
//fileprivate let recommendedReuseIden = "RecommendationCollectionViewCell"
//fileprivate let recommendedcCllNibName = "RecommendationCollectionViewCell"
//
//class HomePagaingCollectionViewCell: UICollectionViewCell {
//    var collectionView: UICollectionView!{
//        didSet{
//            self.collectionView.backgroundColor = UIColor.white
//            self.collectionView.delegate = self
//            self.collectionView.dataSource = self
//            let nib = UINib(nibName: recommendedcCllNibName, bundle: nil)
//            self.addSubview(self.collectionView)
//            self.collectionView.register(nib, forCellWithReuseIdentifier: recommendedReuseIden)
//        }
//    }
//    
//    var pageInfo: PageInfo!{
//        didSet{
//            let flowLayout = UICollectionViewFlowLayout()
//            flowLayout.scrollDirection = .vertical
//            let frame = CGRect(x: 0, y: 0, width: App.screenWidth, height: self.pageInfo.pageHeight)
//            self.collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
//        }
//    }
//    
//  }
//
//extension HomePagaingCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return self.pageInfo.pageType == .overview ? 2 : 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1 //each item is itself a colleciton view / a slider
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        var cell: UICollectionViewCell!
//        if self.pageInfo.pageType == .overview {
//            
//            
//            
//            cell = collectionView.dequeueReusableCell(withReuseIdentifier:recommendedReuseIden , for: indexPath) as! RecommendationCollectionViewCell
//
//        }else{
//            
//        }
//        return cell
//    }
//}
//
//extension HomePagaingCollectionViewCell: UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 100, height: 100)
//    }
//}
