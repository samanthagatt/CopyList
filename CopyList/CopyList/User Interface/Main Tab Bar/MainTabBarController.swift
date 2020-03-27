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
            let nav = viewControllers?[0] as? UINavigationController
            let spotifyPlaylistsVC = nav?.viewControllers[0] as? SpotifyPlaylistsTableViewController
            spotifyPlaylistsVC?.spotifyPlaylistManager = manager
            spotifyPlaylistsVC?.spotifyPlaylistManager?.getPlaylists() { completion in
                switch completion {
                case .success(let playlists):
                    spotifyPlaylistsVC?.spotifyPlaylists = playlists.items ?? []
                // TODO: Handle errors
                case .failure(_, _):
                    return
                }
            }
        }
    }
}
