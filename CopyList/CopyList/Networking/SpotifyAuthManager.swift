//
//  SpotifyAuthManager.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/5/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import Foundation

class SpotifyAuthManager {
    
    static let baseURLString = "https://accounts.spotify.com/"
    
    var accessToken: String?
    
    var requestAuthorizationURL: URL? = {
        return NetworkManager.shared.constructURL(baseURLString: SpotifyAuthManager.baseURLString, appendingPaths: ["authorize"], queries: ["client_id": clientID, "response_type": "code", "redirect_uri": redirectURI, "state": "this is the stateeeee", "scope": "playlist-read-private playlist-read-collaborative"])
    }()
    
    func requestRefreshAndAccessTokens(code: String) {
        NetworkManager.shared.makeRequest(method: .post, baseURLString: SpotifyAuthManager.baseURLString, appendingPaths: ["api", "token"], bodyForFormEncoding: ["grant_type": "authorization_code", "code": code, "redirect_uri": redirectURI, "client_id": clientID, "client_secret": clientSecret]) { (tokens: AccessAndRefreshTokenResponse?, statusCode, networkError) in
            if let error = networkError {
                print(error)
            }
            guard let tokens = tokens,
                let accessToken = tokens.accessToken,
                let refreshToken = tokens.refreshToken else {
                print("no tokens returned")
                print("status code:", statusCode ?? "no status code")
                return
            }
            self.accessToken = accessToken
            KeychainManager.save(refreshToken, for: spotifyRefreshKey)
            print(KeychainManager.get(spotifyRefreshKey) ?? "nothing stored in keychain!!")
        }
    }
    
    func refreshAccessToken() {
        
    }
}
