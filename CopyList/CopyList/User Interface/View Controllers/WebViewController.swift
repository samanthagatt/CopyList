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
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = urlToLoad else { return }
        webView.load(URLRequest(url: url))
        
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = cancelBarButton
        
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true)
    }
}

private typealias WebViewNavigationDelegate = WebViewController
extension WebViewNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                decisionHandler(.allow)
                return
        }
        if components.scheme == "com.samanthagatt.copylist" {
            decisionHandler(.cancel)
            dismiss(animated: true)
            UIApplication.shared.open(url)
        } else {
            decisionHandler(.allow)
        }
    }
}
