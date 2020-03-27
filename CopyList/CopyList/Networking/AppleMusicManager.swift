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
            // user doesn't have an account
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
    
    func getPlaylists(completion: @escaping (NetworkCompletion<[ApplePlaylist], Data?>) -> Void) {
        NetworkManager.shared.makeRequest(baseURLString: "https://api.music.apple.com/v1/me/library/", appendingPaths: ["playlists"], headers: ["Authorization": "Bearer \(appleDeveloperToken)", "Music-User-Token": userToken ?? ""]) { (dictCompletion: NetworkCompletion<[String: [ApplePlaylist]], Data?>) in
            switch dictCompletion {
            case .success(let dict):
                guard let playlists = dict["data"] else {
                    completion(.failure(response: nil, error: .noDataReturned))
                    return
                }
                completion(.success(response: playlists))
            case .failure(let response, let error):
                completion(.failure(response: response, error: error))
            }
        }
        
        /*
         success: { (dict: [String: [ApplePlaylist]]) in
            guard let playlists = dict["data"] else {
                completion(nil, nil, nil)
                return
            }
            completion(playlists, nil, nil)
        }, failure: { (error, _: Data?) in
            completion(nil, nil, error)
        }
         */
    }
}
