//
//  LoginViewController.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/5/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import UIKit
import WebKit
import MediaPlayer

class LoginViewController: UIViewController {

    lazy var spotifyLoginButton: UIButton = {
        return ViewManager.button(titlesForStates: [("LOGIN WITH SPOTIFY", .normal)],
                                  textColorsForStates: [(.white, .normal)],
                                  font: UIFont.preferredFont(forTextStyle: .title2),
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
        let webViewController = WebViewController()
        webViewController.urlToLoad = SpotifyManager().requestAuthorizationURL
        let navController = UINavigationController(rootViewController: webViewController)
        present(navController, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        MPMediaLibrary.requestAuthorization { status in
            if status != .authorized {
                let alertController = UIAlertController(title: "Uh oh", message: "CopyList requires access to the music on your divice in order to work. You can allow the app access by going to Settings -> Privacy -> Media & Apple Music", preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true)
            }
        }
    }
}

