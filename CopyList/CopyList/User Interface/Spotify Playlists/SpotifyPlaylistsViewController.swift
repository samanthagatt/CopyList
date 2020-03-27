//
//  SpotifyPlaylistsViewController.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/6/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import UIKit

class SpotifyPlaylistsTableViewController: UITableViewController {
    static let playlistCellID = "SpotifyPlaylistCell"
    static let showTracksSegueID = "ShowPlaylistTracks"
    
    var spotifyPlaylistManager: SpotifyPlaylistManager?
    var spotifyPlaylists: [SpotifyPlaylist] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Log out", message: "Are you sure you'd like to log out?", preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
            KeychainManager.delete(spotifyRefreshKey)
            self.spotifyPlaylistManager?.authManager.accessToken = nil
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(logOutAction)
        present(alertController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Self.showTracksSegueID {
            guard let playlist = sender as? SpotifyPlaylist,
                let destVC = segue.destination as? SpotifyTracksTableViewController else { return }
            destVC.navigationItem.title = playlist.name ?? ""
            spotifyPlaylistManager?.getTracks(in: playlist.id ?? "") { completion in
                switch completion {
                case .success(let tracks):
                    destVC.tracks = tracks.items ?? []
                // TODO: Handle errors
                case .failure(_, _):
                    return
                }
            }
        }
    }
}

// MARK: Table View Data Source
extension SpotifyPlaylistsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spotifyPlaylists.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.playlistCellID, for: indexPath)
        cell.textLabel?.text = spotifyPlaylists[indexPath.row].name
        return cell
    }
}

// MARK: Table View Delegate
extension SpotifyPlaylistsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlist = spotifyPlaylists[indexPath.row]
        performSegue(withIdentifier: Self.showTracksSegueID, sender: playlist)
    }
}
