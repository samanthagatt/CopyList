//
//  PlaylistsViewController.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/6/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import UIKit

class PlaylistsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let playlistCellID = "PlaylistCell"
    
    var spotifyManager: SpotifyManager?
    
    var spotifyPlaylistController: SpotifyPlaylistController? {
        didSet {
            playlistTableView.reloadData()
        }
    }
    
    lazy var playlistTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: PlaylistsViewController.playlistCellID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(playlistTableView)
        NSLayoutConstraint.activate([
            playlistTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playlistTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            playlistTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            playlistTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
}

private typealias TableViewDataSource = PlaylistsViewController
extension TableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spotifyPlaylistController?.playlists.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistsViewController.playlistCellID, for: indexPath)
        cell.textLabel?.text = spotifyPlaylistController?.playlists[indexPath.row].name
        return cell
    }
}

private typealias TableViewDelegate = PlaylistsViewController
extension TableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlist = spotifyPlaylistController?.playlists[indexPath.row]
        let detailVC = PlaylistDetailViewController()
        detailVC.navigationItem.title = playlist?.name ?? ""
        navigationController?.pushViewController(detailVC, animated: true)
        spotifyManager?.getTracks(in: playlist?.id ?? "", completion: { (spotifyResponse, statusCode, networkError) in
            print(statusCode ?? "no status code")
            print(networkError ?? "no network error")
            guard let response = spotifyResponse else {
                print("no response")
                return
            }
            detailVC.trackController = SpotifyTrackController(tracks: response.items)
        })
    }
}
