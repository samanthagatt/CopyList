//
//  WebViewController.swift
//  CopyList
//
//  Created by Samantha Gatt on 7/5/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var urlToLoad: URL?
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = webView
        
        guard let url = urlToLoad else { return }
        webView.load(URLRequest(url: url))
    }
}
