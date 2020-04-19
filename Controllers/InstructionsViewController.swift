//
//  InstructionsViewController.swift
//  SudokuIOS
//
//  Created by Terry Nippard on 2020-04-11.
//  Copyright © 2020 Xcode User. All rights reserved.
//

// Author: Terry Nippard

import UIKit
import WebKit

class InstructionsViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet var webView: WKWebView!
    @IBOutlet var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up the web view to show the Sudoku Wikipedia page
        let urlAddress = URL(string: "https://en.wikipedia.org/wiki/Sudoku")
        let url = URLRequest(url: urlAddress!)
        webView.load(url)
        webView.navigationDelegate = self
    }
    
    // when the web page is loading
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // show the activity indicator and animate it
        activity.isHidden = false
        activity.startAnimating()
    }
    
    // when the web page finished loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // hide the activity indicator and stop its animation
        activity.isHidden = true
        activity.stopAnimating()
    }
}
