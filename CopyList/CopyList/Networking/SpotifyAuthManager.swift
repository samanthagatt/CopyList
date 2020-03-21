//
//  SpotifyAuthManager.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/5/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import Foundation

class SpotifyAuthManager {
    
    // TODO: Rate Limiting
    // If Web API returns status code 429, it means that you have sent too many requests.
    // When this happens, check the Retry-After header, where you will see a number displayed.
    // This is the number of seconds that you need to wait, before you try your request again.
    
    static let baseURLString = "https://accounts.spotify.com/"
    
    var accessToken: String?
    private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    var requestAuthorizationURL: URL? = {
        return NetworkManager.constructURL(baseURLString: SpotifyAuthManager.baseURLString, appendingPaths: ["authorize"], queries: ["client_id": clientID, "response_type": "code", "redirect_uri": redirectURI, "state": "this is the stateeeee", "show_dialog": "true", "scope": "playlist-read-private playlist-read-collaborative"])
    }()
    
    func requestRefreshAndAccessTokens(code: String, completion: @escaping (Bool?, Int?) -> Void) {
        guard let encodedData = NetworkManager.formEncode(["grant_type": "authorization_code", "code": code, "redirect_uri": redirectURI, "client_id": clientID, "client_secret": clientSecret]) else {
            completion(false, nil)
            return
        }
        NetworkManager.shared.makeRequest(baseURLString: Self.baseURLString, appendingPaths: ["api", "token"], method: .post, encodedData: encodedData, decoder: decoder,
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
        NetworkManager.shared.makeRequest(baseURLString: Self.baseURLString, appendingPaths: ["api", "token"], method: .post, encodedData: encodedData, decoder: decoder,
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
}
