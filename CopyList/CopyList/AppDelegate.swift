//
//  AppDelegate.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/5/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        if let refreshToken = KeychainManager.get(spotifyRefreshKey) {
            let tabController = UIStoryboard(name: "MainTabBar", bundle: .main).instantiateInitialViewController() as? MainTabBarController
            let spotifyAuthManager = SpotifyAuthManager()
            spotifyAuthManager.refreshAccessToken(refreshToken) { _ in
                tabController?.spotifyPlaylistManager = SpotifyPlaylistManager(spotifyAuthManager)
            }
            window?.rootViewController = tabController
        } else {
            window?.rootViewController = LoginViewController()
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let scheme = components.scheme, scheme == redirectScheme,
            let host = components.host, host == "oauth",
            let queryItems = components.queryItems else { return false }
        
        if components.path.contains("spotify") {
            var code: String?, error: String?, state: String?
            for queryItem in queryItems {
                switch queryItem.name {
                case "code":
                    code = queryItem.value
                case "error":
                    error = queryItem.value
                case "state":
                    state = queryItem.value
                default:
                    break
                }
            }
            if let error = error {
                print("There was an error!!", error)
            }
            if let code = code, let _ = state {
                let manager = SpotifyAuthManager()
                manager.requestRefreshAndAccessTokens(code: code) { success in
                    if success {
                        let tabController = UIStoryboard(name: "MainTabBar", bundle: .main).instantiateInitialViewController() as? MainTabBarController
                        tabController?.spotifyPlaylistManager = SpotifyPlaylistManager(manager)
                        self.window?.rootViewController = tabController
                        self.window?.makeKeyAndVisible()
                    }
                    // TODO: Handle errors
                }
            }
        }
        return true
    }
}

