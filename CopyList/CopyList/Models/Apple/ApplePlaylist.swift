//
//  ApplePlaylist.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/8/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import Foundation

struct ApplePlaylist: Decodable {
    var id: String?
    var type: String?
    var href: String?
    var attributes: Attributes?
}

struct Attributes: Decodable {
    var playParams: PlayParameters?
    var artwork: Artwork?
    var canEdit: Bool?
    var name: String?
}

struct PlayParameters: Decodable {
    var id: String?
    var kind: String?
    var isLibrary: Bool?
}
