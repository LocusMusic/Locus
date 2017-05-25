//
//  RecentlyVisitedCollectionTableViewCell.swift
//  Locus
//
//  Created by Xie kesong on 5/25/17.
//  Copyright © 2017 ___Locus___. All rights reserved.
//

import UIKit

let RecentlyVisitedCollectionTableViewCellReuseIden = "RecentlyVisitedCollectionTableViewCell"
let RecentlyVisitedCollectionTableViewCellNibName = "RecentlyVisitedCollectionTableViewCell"


protocol RecentlyVisitedCollectionTableViewCellDelegate: class  {
    func spotThumbnailImageViewImageTapped(spot: TuneSpot)
}

class RecentlyVisitedCollectionTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.alwaysBounceHorizontal = true
            self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            self.collectionView.register( UINib(nibName: SpotThumbnailCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: SpotThumbnailCollectionViewCellReuseIden)
        }
    }
    
    weak var delegate: RecentlyVisitedCollectionViewCellDelegate?
    
    
    var spots: [TuneSpot]?{
        didSet{
            self.collectionView?.reloadData()
        }
    }
}

extension RecentlyVisitedCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spots?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpotThumbnailCollectionViewCellReuseIden, for: indexPath) as! SpotThumbnailCollectionViewCell
        cell.delegate = self
        cell.spot = self.spots?[indexPath.row]
        return cell
    }
}

extension RecentlyVisitedCollectionTableViewCell:UICollectionViewDelegateFlowLayout{
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

extension RecentlyVisitedCollectionTableViewCell: SpotThumbnailCollectionViewCellDelegate{
    func spotThumbnailImageViewImageTapped(spot: TuneSpot) {
        self.delegate?.spotThumbnailImageViewImageTapped(spot: spot)
    }
}

