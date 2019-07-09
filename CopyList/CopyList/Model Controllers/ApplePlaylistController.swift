//
//  ApplePlaylistController.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/8/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import Foundation

class ApplePlaylistController {
    
    var playlists: [ApplePlaylist]
    
    init(playlists: [ApplePlaylist]? = nil) {
        self.playlists = playlists ?? []
    }
}
