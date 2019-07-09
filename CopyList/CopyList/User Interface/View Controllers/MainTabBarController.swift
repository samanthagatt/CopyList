//
//  MainTabBarController.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/6/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var spotifyManager: SpotifyManager? {
        didSet {
            guard let manager = spotifyManager else { return }
            spotifyPlaylistsVC.spotifyManager = manager
            manager.getPlaylists { (spotifyPlaylists, statusCode, networkError) in
                print(statusCode ?? "no status code")
                print(networkError ?? "no network error")
                guard let playlists = spotifyPlaylists else {
                    print("No playlists returned!")
                    return
                }
                let playlistController = SpotifyPlaylistController(playlists: playlists.items)
                self.spotifyPlaylistsVC.spotifyPlaylistController = playlistController
            }
        }
    }
    
    let spotifyPlaylistsVC: SpotifyPlaylistsViewController = {
        let vc = SpotifyPlaylistsViewController()
        vc.navigationItem.title = "Your Spotify Playlists"
        return vc
    }()
    let appleMusicPlaylistsVC: ApplePlaylistsViewController = {
        let vc = ApplePlaylistsViewController()
        vc.navigationItem.title = "Your Apple Playlists"
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spotifyNav = UINavigationController(rootViewController: spotifyPlaylistsVC)
        spotifyNav.navigationBar.prefersLargeTitles = true
        spotifyNav.tabBarItem.title = "Spotify Playlists"
        addChild(spotifyNav)
        
        let appleNav = UINavigationController(rootViewController: appleMusicPlaylistsVC)
        appleNav.navigationBar.prefersLargeTitles = true
        appleNav.tabBarItem.title = "Apple Playlists"
        addChild(appleNav)
    }
}
