//
//  SpotifyTrackController.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/6/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import Foundation

class SpotifyTrackController {
    var tracks: [SpotifyPlaylistTrack]
    
    init(tracks: [SpotifyPlaylistTrack]? = nil) {
        self.tracks = tracks ?? []
    }
}
