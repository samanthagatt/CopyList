//
//  SpotifyTracksViewController.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/6/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import UIKit

class SpotifyTracksTableViewController: UITableViewController {
    static let trackCellID = "TrackCell"
    var tracks: [SpotifyPlaylistTrack] = [] {
        didSet {
            tableView.reloadData()
        }
    }
}

// MARK: Table View Data Source
extension SpotifyTracksTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.trackCellID, for: indexPath)
        cell.textLabel?.text = tracks[indexPath.row].track?.name
        return cell
    }
}
