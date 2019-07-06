//
//  SpotifyManager.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/5/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import Foundation

class SpotifyManager {
    
    static let baseURLString = "https://accounts.spotify.com/"
    
    var accessToken: String?
    
    var requestAuthorizationURL: URL? = {
        return NetworkManager.shared.constructURL(baseURLString: SpotifyManager.baseURLString, appendingPaths: ["authorize"], queries: ["client_id": clientID, "response_type": "code", "redirect_uri": redirectURI, "state": "this is the stateeeee", "scope": "playlist-read-private playlist-read-collaborative"])
    }()
    
    func requestRefreshAndAccessTokens(code: String, completion: @escaping (Bool?, Int?) -> Void) {
        NetworkManager.shared.makeRequest(method: .post, baseURLString: SpotifyManager.baseURLString, appendingPaths: ["api", "token"], bodyForFormEncoding: ["grant_type": "authorization_code", "code": code, "redirect_uri": redirectURI, "client_id": clientID, "client_secret": clientSecret]) { (tokens: AccessAndRefreshTokenResponse?, statusCode, networkError) in
            if let error = networkError {
                print(error)
                completion(false, statusCode)
                return
            }
            guard let tokens = tokens,
                let accessToken = tokens.accessToken,
                let refreshToken = tokens.refreshToken else {
                completion(false, statusCode)
                return
            }
            self.accessToken = accessToken
            KeychainManager.save(refreshToken, for: spotifyRefreshKey)
            completion(true, statusCode)
        }
    }
    
    func refreshAccessToken() {
        
    }
    
    func getPlaylists(completion: @escaping (SpotifyPageResponse<SpotifyPlaylist>?, Int?, NetworkManager.NetworkError?) -> Void) {
        guard let accessToken = accessToken else {
            print("No access token!!")
            return
        }
        NetworkManager.shared.makeRequest(baseURLString: "https://api.spotify.com/v1/me/playlists", headers: ["Authorization": "Bearer \(accessToken)"], completion: completion)
    }
    
    func getTracks(in id: String, completion: @escaping (SpotifyPageResponse<SpotifyPlaylistTrack>?, Int?, NetworkManager.NetworkError?) -> Void) {
        guard let accessToken = accessToken else {
            print("No access token!!")
            return
        }
        NetworkManager.shared.makeRequest(baseURLString: "https://api.spotify.com/v1/playlists/\(id)/tracks", headers: ["Authorization": "Bearer \(accessToken)"], completion: completion)
    }
}
