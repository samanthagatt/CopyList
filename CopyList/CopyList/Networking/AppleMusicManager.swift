//
//  AppleMusicManager.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/8/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import Foundation
import StoreKit

class AppleMusicManager {
    
    var userToken: String?
    
    private func requestToken(completion: @escaping (Bool, Error?) -> Void) {
        SKCloudServiceController().requestUserToken(forDeveloperToken: appleDeveloperToken) { (token, error) in
            if let token = token {
                self.userToken = token
                completion(true, error)
                return
            }
            completion(false, error)
        }
    }
    
    func getUserToken(completion: @escaping (Bool, Error?) -> Void) {
        let status = SKCloudServiceController.authorizationStatus()
        switch status {
        case .notDetermined:
            SKCloudServiceController.requestAuthorization { access in
                if access == .authorized {
                    self.requestToken(completion: completion)
                } else {
                    completion(false, nil)
                }
            }
        case .authorized:
            self.requestToken(completion: completion)
        default:
            completion(false, nil)
        }
    }
    
    func getPlaylists(completion: @escaping ([ApplePlaylist]?, Int?, NetworkManager.NetworkError?) -> Void) {
        NetworkManager.shared.makeRequest(baseURLString: "https://api.music.apple.com/v1/me/library/", appendingPaths: ["playlists"], headers: ["Authorization": "Bearer \(appleDeveloperToken)", "Music-User-Token": userToken ?? ""]) { (playlistsDict: [String: [ApplePlaylist]]?, statusCode, networkError) in
            guard let dict = playlistsDict, let playlists = dict["data"] else {
                completion(nil, statusCode, networkError)
                return
            }
            completion(playlists, statusCode, networkError)
        }
    }
    
    func getTracks(playlistID: String?, completion: @escaping ([ApplePlaylist]?, Int?, NetworkManager.NetworkError?) -> Void) {
        NetworkManager.shared.makeRequest(baseURLString: "https://api.music.apple.com/v1/me/library", appendingPaths: ["playlists", playlistID ?? ""], headers: ["Authorization": "Bearer \(appleDeveloperToken)", "Music-User-Token": userToken ?? ""]) { (playlistsDict: [String: [ApplePlaylist]]?, statusCode, networkError) in
            guard let dict = playlistsDict, let playlists = dict["data"] else {
                completion(nil, statusCode, networkError)
                return
            }
            completion(playlists, statusCode, networkError)
        }
    }
}
