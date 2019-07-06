//
//  ViewController.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/5/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let helloWorldLabel = UILabel()
        helloWorldLabel.text = "Hello, World!"
        helloWorldLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(helloWorldLabel)
        NSLayoutConstraint.activate([
            helloWorldLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            helloWorldLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }


}

