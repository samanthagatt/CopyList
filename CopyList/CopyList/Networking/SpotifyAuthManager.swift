//
//  SpotifyAuthManager.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/5/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import Foundation

class SpotifyAuthManager {
    
    static let baseURLString = "https://accounts.spotify.com/authorize"
    
    var requestAuthorizationURL: URL? = {
        return NetworkManager.shared.constructURL(baseURLString: SpotifyAuthManager.baseURLString, queries: ["client_id": "a0963aaca7e54546a0a4f21dc9fac7a1", "response_type": "code", "redirect_uri": "com.samanthagatt.copylist://oauth/spotify/", "state": "this is the stateeeee"])
    }()
}
