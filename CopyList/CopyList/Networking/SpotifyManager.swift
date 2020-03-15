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
    private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    var requestAuthorizationURL: URL? = {
        return NetworkManager.constructURL(baseURLString: SpotifyManager.baseURLString, appendingPaths: ["authorize"], queries: ["client_id": clientID, "response_type": "code", "redirect_uri": redirectURI, "state": "this is the stateeeee", "show_dialog": "true", "scope": "playlist-read-private playlist-read-collaborative"])
    }()
    
    func requestRefreshAndAccessTokens(code: String, completion: @escaping (Bool?, Int?) -> Void) {
        guard let encodedData = NetworkManager.formEncode(["grant_type": "authorization_code", "code": code, "redirect_uri": redirectURI, "client_id": clientID, "client_secret": clientSecret]) else {
            completion(false, nil)
            return
        }
        NetworkManager.shared.makeRequest(baseURLString: SpotifyManager.baseURLString, appendingPaths: ["api", "token"], method: .post, encodedData: encodedData, decoder: decoder,
        success: { (tokens: AccessAndRefreshTokenResponse) in
            guard let accessToken = tokens.accessToken,
                let refreshToken = tokens.refreshToken else {
                    completion(false, nil)
                    return
            }
            self.accessToken = accessToken
            KeychainManager.save(refreshToken, for: spotifyRefreshKey)
            completion(true, nil)
        }, failure: { (error, _: Data?) in
            completion(false, nil)
        })
    }
    
    func refreshAccessToken(_ refreshToken: String, completion: @escaping (Bool?, Int?) -> Void) {
        let bodyForFormEncoding = ["grant_type": "refresh_token", "refresh_token": refreshToken, "redirect_uri": redirectURI, "client_id": clientID, "client_secret": clientSecret]
        guard let encodedData = NetworkManager.formEncode(bodyForFormEncoding) else {
            completion(false, nil)
            return
        }
        NetworkManager.shared.makeRequest(baseURLString: SpotifyManager.baseURLString, appendingPaths: ["api", "token"], method: .post, encodedData: encodedData, decoder: decoder,
        success: { (tokens: AccessAndRefreshTokenResponse) in
            guard let accessToken = tokens.accessToken else {
                completion(false, nil)
                return
            }
            self.accessToken = accessToken
            if let refreshToken = tokens.refreshToken {
                KeychainManager.save(refreshToken, for: spotifyRefreshKey)
            }
            completion(true, nil)
        }, failure: { (error, _: Data?) in
            completion(false, nil)
        })
    }
    
    func getPlaylists(completion: @escaping (SpotifyPageResponse<SpotifyPlaylist>?, Int?, NetworkManager.NetworkError?) -> Void) {
        guard let accessToken = accessToken else {
            print("No access token!!")
            return
        }
        NetworkManager.shared.makeRequest(baseURLString: "https://api.spotify.com/v1/me/playlists", headers: ["Authorization": "Bearer \(accessToken)"], decoder: decoder,
        success: { (playlists: SpotifyPageResponse<SpotifyPlaylist>) in
            completion(playlists, nil, nil)
        }, failure: { (error, _: Data?) in
            completion(nil, nil, error)
        })
    }
    
    func getTracks(in id: String, completion: @escaping (SpotifyPageResponse<SpotifyPlaylistTrack>?, Int?, NetworkManager.NetworkError?) -> Void) {
        guard let accessToken = accessToken else {
            print("No access token!!")
            return
        }
        NetworkManager.shared.makeRequest(baseURLString: "https://api.spotify.com/v1/playlists/\(id)/tracks", headers: ["Authorization": "Bearer \(accessToken)"], decoder: decoder,
        success: { (tracks: SpotifyPageResponse<SpotifyPlaylistTrack>) in
            completion(tracks, nil, nil)
        }, failure: { (error, _: Data?) in
            completion(nil, nil, error)
        })
    }
}
