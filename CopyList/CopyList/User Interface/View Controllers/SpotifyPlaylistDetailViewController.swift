//
//  SpotifyPlaylistDetailViewController.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/6/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import UIKit

class SpotifyPlaylistDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var trackController: SpotifyTrackController? {
        didSet {
            tracksTableView.reloadData()
        }
    }
    
    lazy var tracksTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: SpotifyPlaylistsViewController.playlistCellID)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
                
        view.addSubview(tracksTableView)
        NSLayoutConstraint.activate([
            tracksTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tracksTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tracksTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tracksTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
}

private typealias TableViewDataSource = SpotifyPlaylistDetailViewController
extension TableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackController?.tracks.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SpotifyPlaylistsViewController.playlistCellID, for: indexPath)
        cell.textLabel?.text = trackController?.tracks[indexPath.row].track?.name
        return cell
    }
}
