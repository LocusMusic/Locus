//
//  RecommendationCollectionViewCell.swift
//  Locus
//
//  Created by Xie kesong on 4/25/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

fileprivate let spotThumbnailReuseIden = "SpotThumbnailReuseIden"
fileprivate let spotThumbnailNibName = "SpotThumbnailCollectionViewCell"


protocol RecentlyVisitedCollectionViewCellDelegate: class  {
    func spotThumbnailImageViewImageTapped(spot: TuneSpot)
}

class RecentlyVisitedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.alwaysBounceHorizontal = true
            self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            self.collectionView.register( UINib(nibName: spotThumbnailNibName, bundle: nil), forCellWithReuseIdentifier: spotThumbnailReuseIden)
        }
    }
    
    weak var delegate: RecentlyVisitedCollectionViewCellDelegate?

    
    var spots: [TuneSpot]?{
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension RecentlyVisitedCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spots?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: spotThumbnailReuseIden, for: indexPath) as! SpotThumbnailCollectionViewCell
        cell.delegate = self
        cell.spot = self.spots?[indexPath.row]
        return cell
    }
}

extension RecentlyVisitedCollectionViewCell:UICollectionViewDelegateFlowLayout{
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

extension RecentlyVisitedCollectionViewCell: SpotThumbnailCollectionViewCellDelegate{
    func spotThumbnailImageViewImageTapped(spot: TuneSpot) {
        self.delegate?.spotThumbnailImageViewImageTapped(spot: spot)
    }
}

