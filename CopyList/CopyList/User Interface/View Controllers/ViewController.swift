//
//  ViewController.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/5/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    lazy var spotifyLoginButton: UIButton = {
        return ViewManager.button(titlesForStates: [("Login with Spotify", .normal)],
                                  textColorsForStates: [(.black, .normal)],
                                  contentEdgeInsets: UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10))
            .addStyling(backgroundColor: .spotifyGreen, cornerRadius: 12)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        spotifyLoginButton.addTarget(self, action: #selector(getAccess), for: .touchUpInside)
        
        view.addSubview(spotifyLoginButton)
        NSLayoutConstraint.activate([
            spotifyLoginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            spotifyLoginButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    @objc func getAccess() {
        if let url = SpotifyAuthManager().requestAuthorizationURL {
            UIApplication.shared.open(url)
        }
    }
}

