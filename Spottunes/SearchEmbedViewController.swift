//
//  SearchEmbedViewController.swift
//  Spottunes
//
//  Created by Leo Wong on 5/3/17.
//  Copyright © 2017 ___Spottunes___. All rights reserved.
//

import UIKit

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
    
    weak var customDelegate: HomeEmbedPageViewControllerDelegate?
    
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
        
        self.setSongPageActive()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSongPageActive(){
        if let songVC = self.childControllers.first {
            self.setViewControllers([songVC], direction: .reverse, animated: true, completion: nil)
        }
    }
    
    func setArtistPageActive(){
        let artistVC = self.childControllers[1]
        self.setViewControllers([artistVC], direction: .forward, animated: true, completion: nil)
    }
    
    func setPlaylistPageActive(){
        let playlistVC = self.childControllers[2]
        self.setViewControllers([playlistVC], direction: .forward, animated: true, completion: nil)
    }
    
    func setSpotPageActive(){
        let spotVC = self.childControllers[3]
        self.setViewControllers([spotVC], direction: .forward, animated: true, completion: nil)
    }
    
    func songPageShouldBecomeActive(_ notification: Notification){
        self.setSongPageActive()
    }
    
    func artistPageShouldBecomeActive(_ notification: Notification){
        self.setArtistPageActive()
    }
    
    func playlistPageShouldBecomeActive(_ notification: Notification){
        self.setPlaylistPageActive()
    }

    func spotPageShouldBeActive(_ notification: Notification){
        self.setSpotPageActive()
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
//        print("============ VIEWCONTROLLERBEFORE CALLED ===========")
//        print(viewController)
        guard let currentIndex = self.childControllers.index(of: viewController) else{
            return nil
        }
        let prevIndex = max(currentIndex - 1, 0)
        return currentIndex == prevIndex ? nil : self.childControllers[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        print("======== VIEWCONTROLLERAFTER CALLED ============")
//        print(viewController)
        guard let currentIndex = self.childControllers.index(of: viewController) else{
            return nil
        }
        let nextIndex = min(currentIndex + 1, self.childControllers.count - 1)
        return  currentIndex == nextIndex ? nil : self.childControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.customDelegate?.willTransitionToPage(viewController: self.childControllers[0], pageIndex: self.childControllers.index(of: self.viewControllers!.first!)!)
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
