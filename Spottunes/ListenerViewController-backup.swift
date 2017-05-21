////
////  ListenerViewController.swift
////  Spottunes
////
////  Created by Xie kesong on 4/29/17.
////  Copyright © 2017 ___Spottunes___. All rights reserved.
////
//
//import UIKit
//
//fileprivate let reuseIden = "ListenerCollectionViewCell"
//fileprivate let xibName = "ListenerCollectionViewCell"
//
//fileprivate struct CollectionViewUI{
//    static let UIEdgeSpace: CGFloat = 32.0
//    static let MinmumLineSpace: CGFloat = 16.0
//    static let MinmumInteritemSpace: CGFloat = 16.0
//}
//
//class ListenerViewController: UIViewController {
//    
//    var listenerLikeReceivedPairs: [(key: User, value: Int)]?
//    
//    var profileImageWidth: CGFloat = 0
//    
//    @IBOutlet weak var collectionView: UICollectionView!{
//        didSet{
//            self.collectionView.delegate = self
//            self.collectionView.dataSource = self
//            self.collectionView.alwaysBounceVertical = true
//            self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0)
//            
//            //register for recently visited spot cell and reuse
//            self.collectionView.register(UINib(nibName: xibName, bundle: nil), forCellWithReuseIdentifier: reuseIden)
//        }
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if self.listenerLikeReceivedPairs != nil{
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        }
//    }
//}
//
//extension ListenerViewController: UICollectionViewDelegate, UICollectionViewDataSource{
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.listenerLikeReceivedPairs?.count ?? 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIden, for: indexPath) as! ListenerCollectionViewCell
//        cell.listenerLikePair = self.listenerLikeReceivedPairs?[indexPath.row]
//        cell.updateImageLayerCorner(width: self.profileImageWidth)
//        return cell
//    }
//}
//
//extension ListenerViewController: UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let length = (self.view.frame.size.width - 2 * CollectionViewUI.UIEdgeSpace - CollectionViewUI.MinmumInteritemSpace) / 2 ;
//        self.profileImageWidth = length
//        return CGSize(width: length, height: length + 60)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return CollectionViewUI.MinmumLineSpace
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return  UIEdgeInsetsMake( CollectionViewUI.UIEdgeSpace,  CollectionViewUI.UIEdgeSpace,  CollectionViewUI.UIEdgeSpace,  CollectionViewUI.UIEdgeSpace)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return CollectionViewUI.MinmumInteritemSpace
//    }
//}
//
