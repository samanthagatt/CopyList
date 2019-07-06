//
//  SpotifySimplifiedArtist.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/6/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import Foundation

struct SpotifySimplifiedArtist: Decodable {
    var externalURLs: [String: String]?
    var href: String?
    var id: String?
    var name: String?
    var uri: String?
}
