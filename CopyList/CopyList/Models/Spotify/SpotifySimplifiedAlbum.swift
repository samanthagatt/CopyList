//
//  SpotifySimplifiedAlbum.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/6/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import Foundation

struct SpotifySimplifiedAlbum: Decodable {
    var name: String?
    var releaseDate: String?
    var uri: String?
    var id: String?
    var href: String?
}
