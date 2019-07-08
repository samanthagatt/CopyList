//
//  ApplePlaylistsViewController.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/8/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import UIKit
import MediaPlayer

class ApplePlaylistsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let playlistCellID = "ApplePlaylistCell"
    
    var spotifyManager: SpotifyManager?
    
    var playlists: [MPMediaItemCollection] = {
        return MPMediaQuery.playlists().collections ?? []
    }() {
        didSet {
            playlistTableView.reloadData()
        }
    }
    
    lazy var playlistTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ApplePlaylistsViewController.playlistCellID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let barButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOut))
        barButtonItem.tintColor = .red
        navigationItem.leftBarButtonItem = barButtonItem
        
        view.addSubview(playlistTableView)
        NSLayoutConstraint.activate([
            playlistTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playlistTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            playlistTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            playlistTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
            ])
    }
    
    @objc func logOut() {
        let alertController = UIAlertController(title: "Log out", message: "Are you sure you'd like to log out?", preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
            KeychainManager.delete(spotifyRefreshKey)
            self.spotifyManager?.accessToken = nil
            self.present(LoginViewController(), animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(logOutAction)
        present(alertController, animated: true)
    }
}

private typealias TableViewDataSource = ApplePlaylistsViewController
extension TableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ApplePlaylistsViewController.playlistCellID, for: indexPath)
        cell.textLabel?.text = playlists[indexPath.row].value(forProperty: MPMediaPlaylistPropertyName) as? String
        return cell
    }
}

private typealias TableViewDelegate = ApplePlaylistsViewController
extension TableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
