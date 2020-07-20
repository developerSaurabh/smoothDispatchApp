//
//  MessageViewController.swift
//  Smoothdispatch
//
//  Created by Ravinder on 21/09/19.
//  Copyright © 2019 Ravinder. All rights reserved.
//

import UIKit
import WebKit
class MessageViewController: UIViewController,WKNavigationDelegate {
    
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
       // "http://" + Port + "/justdrivermessages.aspx?dot=" + DOT + "&driverid=" + DriverId + "&truckid=" + TruckId + "&trailerid=" + TrailerId + "&deviceid=" + PhoneNumber);
        
        let url = URL(string: "http://www.incabdispatch.com/justdrivermessages.aspx?dot=2150093&driverid=1&truckid=1&trailerid=1&deviceid=4174553609&+918629830566")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

}
