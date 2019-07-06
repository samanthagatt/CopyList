//
//  SpotifyTrack.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/6/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import Foundation

struct SpotifyTrack: Decodable {
    var href: String?
    var id: String?
    var discNumber: Int?
    var durationMs: Int?
    var explicit: Bool?
    var isPlayable: Bool?
    var name: String?
    var previewURL: String?
    var uri: String?
    var artists: [SpotifySimplifiedArtist]?
    var album: SpotifySimplifiedAlbum?
}
