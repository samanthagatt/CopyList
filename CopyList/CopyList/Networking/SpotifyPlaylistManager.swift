//
//  SpotifyPlaylistManager.swift
//  CopyList
//
//  Created by Samantha Gatt on 3/15/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation

class SpotifyPlaylistManager {
    
    let authManager: SpotifyAuthManager
    
    private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    init(_ authManager: SpotifyAuthManager) {
        self.authManager = authManager
    }
    
    func getPlaylists(completion: @escaping (NetworkCompletion<SpotifyPageResponse<SpotifyPlaylist>, Data?>) -> Void) {
        guard let accessToken = authManager.accessToken else {
            print("No access token!!")
            return
        }
        NetworkManager.shared.makeRequest(baseURLString: "https://api.spotify.com/v1/me/playlists", queries: ["limit": "50"], headers: ["Authorization": "Bearer \(accessToken)"], decoder: decoder, completion: completion)
    }
    
    func getTracks(in id: String, completion: @escaping (NetworkCompletion<SpotifyPageResponse<SpotifyPlaylistTrack>, Data?>) -> Void) {
        guard let accessToken = authManager.accessToken else {
            print("No access token!!")
            return
        }
        NetworkManager.shared.makeRequest(baseURLString: "https://api.spotify.com/v1/playlists/\(id)/tracks", headers: ["Authorization": "Bearer \(accessToken)"], decoder: decoder, completion: completion)
    }
}
