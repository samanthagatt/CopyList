//
//  AccessAndRefreshTokenResponse.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/6/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import Foundation

struct AccessAndRefreshTokenResponse: Decodable {
    var accessToken: String?
    var tokenType: String?
    var scope: String?
    var expiresIn: Int?
    var refreshToken: String?
}
