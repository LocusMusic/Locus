////
////  AddMusicViewController.swift
////  Spottunes
////
////  Created by Xie kesong on 5/4/17.
////  Copyright © 2017 ___Spottunes___. All rights reserved.
////
//
//import UIKit
//
//fileprivate let addMusicEmbedSegueIden = "AddMusicEmbedSegueIden"
//fileprivate let globalTabBarEmbedSegueIden = "GlobalTabBarEmbedSegueIden"
//fileprivate let spotThumbnailReuseIden = "SpotThumbnailReuseIden"
//fileprivate let spotThumbnailNibName = "SpotThumbnailCollectionViewCell"
//
//
//protocol AddMusicViewControllerDelegate : class {
//    func keyboardDidShow(keyboardSize: CGSize)
//    func keyboardWillHide()
//    func didSelectSpot(spot: TuneSpot)
//    func closeBtnTapped(playlistPickerContainerView: UIView)
//}
//
//class AddMusicViewController: UIViewController {
//    
//    @IBOutlet weak var collectionView: UICollectionView!{
//        didSet{
//            self.collectionView.delegate = self
//            self.collectionView.dataSource = self
//            self.collectionView.alwaysBounceHorizontal = true
//            self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//            self.collectionView.register( UINib(nibName: spotThumbnailNibName, bundle: nil), forCellWithReuseIdentifier: spotThumbnailReuseIden)
//        }
//    }
//    @IBOutlet weak var contentStackView: UIStackView!
//    @IBOutlet weak var searchBar: UISearchBar!{
//        didSet{
//            self.searchBar.backgroundImage = UIImage() //remove the search bar border
//            self.searchBar.delegate = self
//            for subView in self.searchBar.subviews  {
//                for subsubView in subView.subviews  {
//                    if let textField = subsubView as? UITextField{
//                        self.searchBarTextField = textField
//                    }
//                }
//            }
//        }
//    }
//    
//    
//    @IBOutlet weak var suggestionView: UIStackView!
//    
//    @IBOutlet weak var playlistPickerContainerView: UIView!
//    
//    
//    @IBOutlet weak var navigationBar: UINavigationBar!
//    
//    
//    @IBAction func crossIconTapped(_ sender: UIBarButtonItem) {
//        self.searchBar.resignFirstResponder()
//        self.delegate?.closeBtnTapped(playlistPickerContainerView: self.playlistPickerContainerView)
//    }
//    
//    weak var delegate: AddMusicViewControllerDelegate?
//    var searchBarTextField: UITextField!
//    var spots: [TuneSpot]?{
//        didSet{
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        }
//    }
//    var selectedSpotImageView : UIImageView?
//    
//    let adjustSearchIconOffset: CGFloat = App.screenWidth / 2 - 30
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationBar.barTintColor = App.Style.NavigationBar.barTintColor
//        self.navigationBar.clipsToBounds = App.Style.NavigationBar.clipsToBounds
//        self.navigationBar.titleTextAttributes = App.Style.NavigationBar.titleTextAttribute
//        
//        //add notification
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: App.LocalNotification.Name.keyboardDidShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: App.LocalNotification.Name.keyboardWillHide, object: nil)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    @IBOutlet weak var searchIconCenterXConstraint: NSLayoutConstraint!
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.searchBarTextField.leftViewMode = .never //don't show the magnify icon
//        self.searchBarTextField.tintColor = App.grayColor
//    }
//    
//    
//    func keyboardDidShow(_ notification: Notification){
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size{
//            self.delegate?.keyboardDidShow(keyboardSize: keyboardSize)
//        }
//    }
//    
//    func keyboardWillHide(_ notification: Notification){
//        self.delegate?.keyboardWillHide()
//    }
//    
//}
//
//extension AddMusicViewController: UICollectionViewDelegate, UICollectionViewDataSource{
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return spots?.count ?? 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: spotThumbnailReuseIden, for: indexPath) as! SpotThumbnailCollectionViewCell
//        cell.spot = self.spots![indexPath.row]
//        return cell
//    }
//}
//
//extension AddMusicViewController:UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let legnth = self.collectionView.frame.size.height
//        return CGSize(width: legnth - 28, height: legnth)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 16
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let spotThumbCell = collectionView.cellForItem(at: indexPath) as! SpotThumbnailCollectionViewCell
//        let thumbImageView = spotThumbCell.thumbImageView
//        if let targetThumbImageView = thumbImageView{
//            self.selectedSpotImageView = UIImageView(image: targetThumbImageView.image)
//            self.selectedSpotImageView?.clipsToBounds = true
//            self.selectedSpotImageView?.layer.cornerRadius = targetThumbImageView.layer.cornerRadius
//            self.contentStackView.addSubview(self.selectedSpotImageView!)
//            let startFrame = targetThumbImageView.convert(targetThumbImageView.frame, to: self.contentStackView)
//            self.selectedSpotImageView?.frame = startFrame
//            let destinationFrame = CGRect(x: 16, y: 0 , width: App.Style.PlaylistSelection.spotThumbnailWidth, height: App.Style.PlaylistSelection.spotThumbnailWidth)
//            self.collectionView.alpha = 0.4
//            self.delegate?.didSelectSpot(spot: self.spots![indexPath.row])
//            self.playlistPickerContainerView.isHidden = false
//            self.playlistPickerContainerView.alpha = 0
//            thumbImageView?.isHidden = true
//            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
//                //animate selected spot imageview to place
//                self.selectedSpotImageView?.frame = destinationFrame
//                //set the rest of UI element to 0 alpha
//                self.suggestionView.alpha = 0
//            }, completion:{
//                finished in
//                if finished{
//                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
//                        self.playlistPickerContainerView.alpha = 1
//                    }, completion: {
//                        finished in
//                        thumbImageView?.isHidden = false
//                        self.selectedSpotImageView?.removeFromSuperview()
//                        self.collectionView.alpha = 1
//                        self.suggestionView.alpha = 1
//                    })
//                }
//            })
//        }
//    }
//}
//
//extension AddMusicViewController: UISearchBarDelegate{
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        self.searchIconCenterXConstraint.constant = self.searchIconCenterXConstraint.constant - adjustSearchIconOffset
//        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//    }
//    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        self.searchIconCenterXConstraint.constant = self.searchIconCenterXConstraint.constant + adjustSearchIconOffset
//    }
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//    }
//}
