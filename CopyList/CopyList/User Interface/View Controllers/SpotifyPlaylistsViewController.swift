//
//  SpotifyPlaylistsViewController.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/6/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import UIKit

class SpotifyPlaylistsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let playlistCellID = "SpotifyPlaylistCell"
    
    var spotifyManager: SpotifyManager?
    
    var spotifyPlaylistController: SpotifyPlaylistController? {
        didSet {
            playlistTableView.reloadData()
        }
    }
    
    lazy var playlistTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: SpotifyPlaylistsViewController.playlistCellID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
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

private typealias TableViewDataSource = SpotifyPlaylistsViewController
extension TableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spotifyPlaylistController?.playlists.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SpotifyPlaylistsViewController.playlistCellID, for: indexPath)
        cell.textLabel?.text = spotifyPlaylistController?.playlists[indexPath.row].name
        return cell
    }
}

private typealias TableViewDelegate = SpotifyPlaylistsViewController
extension TableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlist = spotifyPlaylistController?.playlists[indexPath.row]
        let detailVC = SpotifyPlaylistDetailViewController()
        detailVC.navigationItem.title = playlist?.name ?? ""
        navigationController?.pushViewController(detailVC, animated: true)
        spotifyManager?.getTracks(in: playlist?.id ?? "") { (spotifyResponse, statusCode, networkError) in
            print(statusCode ?? "no status code")
            print(networkError ?? "no network error")
            guard let response = spotifyResponse else {
                print("no response")
                return
            }
            detailVC.trackController = SpotifyTrackController(tracks: response.items)
        }
    }
}
