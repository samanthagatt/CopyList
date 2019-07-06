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
    var id: String?
    var images: [Image]?
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
    
    struct Image: Decodable {
        var width: Int?
        var height: Int?
        var url: String?
    }
    
    enum CodingKeys: String, CodingKey {
        case href, id, name, owner, tracks, type, uri
        case externalURLs = "external_urls"
        case isCollaborative = "collaborative"
        case isPublic = "public"
        case snapshotID = "snapshot_id"
    }
}
