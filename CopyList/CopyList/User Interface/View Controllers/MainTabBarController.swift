//
//  MainTabBarController.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/6/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var spotifyPlaylistManager: SpotifyPlaylistManager? {
        didSet {
            guard let manager = spotifyPlaylistManager else { return }
            spotifyPlaylistsVC.spotifyPlaylistManager = manager
            spotifyPlaylistsVC.spotifyPlaylistManager?.getPlaylists { (spotifyPlaylists, statusCode, networkError) in
                guard let playlists = spotifyPlaylists else {
                    print("No playlists returned!")
                    return
                }
                self.spotifyPlaylistsVC.spotifyPlaylists = playlists.items ?? []
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
