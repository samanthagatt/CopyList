//
//  ApplePlaylistsViewController.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/8/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import UIKit
import StoreKit

class ApplePlaylistsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let playlistCellID = "ApplePlaylistCell"
    
    var appleMusicManager = AppleMusicManager()
    
    var applePlaylists: [ApplePlaylist] = [] {
        didSet {
            playlistTableView.reloadData()
        }
    }
    
    lazy var playlistTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ApplePlaylistsViewController.playlistCellID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        appleMusicManager.getUserToken { (success, error) in
            if success {
                self.appleMusicManager.getPlaylists { completion in
                    switch completion {
                    case .success(let playlists):
                        self.applePlaylists = playlists
                    // TODO: Handle errors
                    case .failure(_, _):
                        return
                    }
                }
            } else {
                let alertController = UIAlertController(title: "Uh oh", message: "CopyList requires access to the music on your divice in order to work. You can allow the app access by going to Settings -> Privacy -> Media & Apple Music", preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true)
            }
        }
        
        view.addSubview(playlistTableView)
        NSLayoutConstraint.activate([
            playlistTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playlistTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            playlistTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            playlistTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
}

// MARK: Table View Data Source
extension ApplePlaylistsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applePlaylists.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ApplePlaylistsViewController.playlistCellID, for: indexPath)
        cell.textLabel?.text = applePlaylists[indexPath.row].attributes?.name
        return cell
    }
}

// MARK: Table View Delegate
extension ApplePlaylistsViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
