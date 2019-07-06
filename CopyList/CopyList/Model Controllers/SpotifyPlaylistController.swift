//
//  SpotifyPlaylistController.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/6/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import Foundation

class SpotifyPlaylistController {
    
    var playlists: [SpotifyPlaylist]
    
    init(playlists: [SpotifyPlaylist]?) {
        self.playlists = playlists ?? []
    }
    
}
