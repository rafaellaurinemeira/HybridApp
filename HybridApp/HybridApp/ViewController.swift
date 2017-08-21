//
//  ViewController.swift
//  HybridApp
//
//  Created by Rafael Laurine Meira on 21/08/17.
//  Copyright © 2017 RLDeveloper. All rights reserved.
//

import UIKit
import JavaScriptCore

final class Singleton {
    static var shared: ViewController! {
        get {
            guard let window = UIApplication.shared.keyWindow, let root = window.rootViewController as? ViewController else { return ViewController() }
            return root
        }
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    let bridge = Bridge()
    
    // MARK: API
    
    override func viewDidLoad() {
        configureWebView()
    }
    
    // MARK: OPEN FUNCTIONS

    open func executeJS(_ js: String) {
        webView.stringByEvaluatingJavaScript(from: js)
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    fileprivate func configureWebView() {
        webView.scrollView.bounces = false
        
        if let path = Bundle.main.path(forResource: "index", ofType: "html") {
            let url = URL(fileURLWithPath: path)
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 20.0)
            webView.loadRequest(request)
        } else {
            let html = "<html><body>ERROR: Start Page at index.html was not found;</body></html>"
            webView.loadHTMLString(html, baseURL: nil)
        }
    }
}

// MARK: UIWebViewDelegate

extension ViewController: UIWebViewDelegate {
    public func webViewDidStartLoad(_ webView: UIWebView) {
        webView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        if let context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext {
            context.setObject(bridge, forKeyedSubscript: "Bridge" as (NSCopying & NSObjectProtocol)!)
        }
    }
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // MARK: TODO
        return true
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        // MARK: TODO
    }
}
