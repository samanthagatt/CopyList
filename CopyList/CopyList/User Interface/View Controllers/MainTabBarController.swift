//
//  MainTabBarController.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/6/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    let spotifyPlaylistsVC: PlaylistsViewController = {
        let vc = PlaylistsViewController()
        vc.tabBarItem.image = .spotifyLogo
        vc.tabBarItem.title = "Spotify Playlists"
        return vc
    }()
    let appleMusicPlaylistsVC: PlaylistsViewController = {
        let vc = PlaylistsViewController()
        vc.tabBarItem.image = .appleLogo
        vc.tabBarItem.title = "Apple Playlists"
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(spotifyPlaylistsVC)
        addChild(appleMusicPlaylistsVC)
    }
}
