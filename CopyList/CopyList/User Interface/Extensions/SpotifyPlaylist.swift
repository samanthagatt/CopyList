//
//  SpotifyPlaylist.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/6/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import Foundation

struct SpotifyPlaylist: Decodable {
    var href: String?
    var externalURLs: [String: String]?
    var isCollaborative: Bool?
    var isPublic: Bool?
    var id: Bool?
    var images: [String]?
    var name: String?
    var owner: SpotifyUser?
    var snapshotID: String?
    var tracks: Tracks?
    var type: String?
    var uri: String?
    
    struct Tracks: Decodable {
        var href: String?
        var total: Int?
    }
    
    enum CodingKeys: String, CodingKey {
        case href, id, images, name, owner, tracks, type, uri
        case externalURLs = "external_urls"
        case isCollaborative = "collaborative"
        case isPublic = "public"
        case snapshotID = "snapshot_id"
    }
}
