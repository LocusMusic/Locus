//
//  SearchEmbedViewController.swift
//  Locus
//
//  Created by Leo Wong on 5/3/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

protocol SearchEmbedPageViewControllerDelegate: UIPageViewControllerDelegate {
    func willTransitionToPage(pageIndex: Int)
}

class SearchEmbedViewController: UIPageViewController {
    
    lazy var childControllers: [UIViewController] = {
        return [self.songsVC, self.artistsVC, self.playlistsVC, self.spotsVC]
    }()
    
    lazy var songsVC: SongsSearchViewController = {
        let songVC = App.searchStoryBoard.instantiateViewController(withIdentifier:App.SearchStoryboardIden.songsSearchViewController) as! SongsSearchViewController
        return songVC
    }()
    
    lazy var artistsVC: ArtistsSearchViewController = {
        let artistsVC = App.searchStoryBoard.instantiateViewController(withIdentifier:App.SearchStoryboardIden.artistsSearchViewController) as! ArtistsSearchViewController
        return artistsVC
    }()

    lazy var playlistsVC: PlaylistsSearchViewController = {
        let playlistsVC = App.searchStoryBoard.instantiateViewController(withIdentifier:App.SearchStoryboardIden.playlistsSearchViewController) as! PlaylistsSearchViewController
        return playlistsVC
    }()
    
    lazy var spotsVC: SpotsSearchViewController = {
        let spotsVC = App.searchStoryBoard.instantiateViewController(withIdentifier:App.SearchStoryboardIden.spotsSearchViewController) as! SpotsSearchViewController
        return spotsVC
    }()
    
    weak var customDelegate: SearchEmbedPageViewControllerDelegate?
    
    var currentPageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        //add notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.songPageShouldBecomeActive(_:)), name: App.LocalNotification.Name.searchSongShouldBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.artistPageShouldBecomeActive(_:)), name: App.LocalNotification.Name.searchArtistsShouldBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playlistPageShouldBecomeActive(_:)), name: App.LocalNotification.Name.searchPlaylistsShouldBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.spotPageShouldBeActive(_:)), name: App.LocalNotification.Name.searchSpotsShouldBecomeActive, object: nil)
        
        self.setSongPageActive(newIndex: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPageHelper(index: Int, newIndex: Int) {
        let viewController = self.childControllers[index]
        var currIndex =  0
        if let vc = self.viewControllers?.first {
            currIndex = self.childControllers.index(of: vc)!
        }
        
        var direction: UIPageViewControllerNavigationDirection = .reverse
        
        if currIndex < newIndex {
            direction = .forward
        }
        self.setViewControllers([viewController], direction: direction, animated: true, completion: nil)
    }
    
    func setSongPageActive(newIndex: Int){
        self.setPageHelper(index: 0, newIndex: newIndex)
    }
    
    func setArtistPageActive(newIndex: Int){
        self.setPageHelper(index: 1, newIndex: newIndex)
    }
    
    func setPlaylistPageActive(newIndex: Int){
        self.setPageHelper(index: 2, newIndex: newIndex)
    }
    
    func setSpotPageActive(newIndex: Int){
        self.setPageHelper(index: 3, newIndex: newIndex)
    }
    
    func songPageShouldBecomeActive(_ notification: Notification){
        if let tag = notification.userInfo?["index"] as? Int {
            self.setSongPageActive(newIndex: tag)
        }
    }
    
    func artistPageShouldBecomeActive(_ notification: Notification){
        if let tag = notification.userInfo?["index"] as? Int {
            self.setArtistPageActive(newIndex: tag)
        }    }
    
    func playlistPageShouldBecomeActive(_ notification: Notification){
        if let tag = notification.userInfo?["index"] as? Int {
            self.setPlaylistPageActive(newIndex: tag)
        }
    }

    func spotPageShouldBeActive(_ notification: Notification) {
        if let tag = notification.userInfo?["index"] as? Int {
            self.setSpotPageActive(newIndex: tag)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based adpplication, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchEmbedViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = self.childControllers.index(of: viewController) else{
            return nil
        }
        let prevIndex = max(currentIndex - 1, 0)
        return currentIndex == prevIndex ? nil : self.childControllers[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = self.childControllers.index(of: viewController) else{
            return nil
        }
        let nextIndex = min(currentIndex + 1, self.childControllers.count - 1)
        return  currentIndex == nextIndex ? nil : self.childControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.customDelegate?.willTransitionToPage(pageIndex: self.childControllers.index(of: self.viewControllers!.first!)!)
//            if let prevVC = previousViewControllers.first {
//                if let index = self.childControllers.index(of: prevVC){
//                    print(self.childControllers.index(of: self.viewControllers!.first!))
//                }
//            }
        }
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 1
    }
}

extension SearchEmbedViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search Bar Text Changed")
        
        //Make Spotify API Call
        let params = [
            "q": searchText,
            "type": "album,artist,playlist,track"
        ]
        
        SpotifyClient.getSearch(parameters: params as [String : AnyObject]) { (resultDict) in
            
            //Tracks
            if let tracksDict = resultDict?["tracks"] as? [String: Any] {
                let tracks = Tracks(dict: tracksDict)
                self.songsVC.data = tracks
            } else {
                self.songsVC.data = nil
            }
            
            //Artists
            if let artistsDict = resultDict?["artists"] as? [String: Any] {
                let artists = Artists(dict: artistsDict)
                self.artistsVC.data = artists
            } else {
                self.artistsVC.data = nil
            }
            
            //Playlists
            if let playlistsDict = resultDict?["playlists"] as? [String: Any] {
                let playlists = Playlists(dict: playlistsDict)
                self.playlistsVC.data = playlists
            } else {
                self.playlistsVC.data = nil
            }
        }
        
        //Get nearby spots
    }
    
    
}
