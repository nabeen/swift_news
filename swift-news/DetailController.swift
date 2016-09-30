//
//  DetailController.swift
//  swift-news
//
//  Created by watanabe_kenichiro on 2016/09/29.
//  Copyright © 2016年 nabeen. All rights reserved.
//

import UIKit

class DetailController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    var entry = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: self.entry["link"] as! String)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
}
