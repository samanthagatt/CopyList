//
//  SpotifyPlaylistsResponse.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/6/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import Foundation

struct SpotifyPlaylistsResponse: Decodable {
    var href: String?
    var items: [SpotifyPlaylist]?
    var limit: Int?
    var next: String?
    var offset: Int?
    var previous: String?
    var total: Int?
}
