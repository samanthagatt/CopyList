//
//  SpotifyPlaylistTrack.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/6/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import Foundation

struct SpotifyPlaylistTrack: Decodable {
    var addedAt: String?
    var addedBy: SpotifyUser?
    var isLocal: Bool?
    var track: SpotifyTrack?
}
