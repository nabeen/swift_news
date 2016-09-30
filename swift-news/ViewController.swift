//
//  ViewController.swift
//  swift-news
//
//  Created by watanabe_kenichiro on 2016/09/29.
//  Copyright © 2016年 nabeen. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var entries = NSArray()
    
    let newsUrlString = "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=https://catatsu.github.io/index.xml&num=10"
    
    @IBAction func refresh(sender: AnyObject) {
        getFeed()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        getFeed()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("news")! as UITableViewCell
        
        let entry = entries[indexPath.row] as! NSDictionary
        
        cell.textLabel?.text = entry["title"] as? String
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("detail", sender: self.entries[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail" {
            let detailController = segue.destinationViewController as! DetailController
            detailController.entry = sender as! NSDictionary
        }
    }
    
    func getFeed() {
        let url = NSURL(string: newsUrlString)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let dataTask = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if let data = data where error == nil {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? NSDictionary
                    let responseData = json!["responseData"] as? NSDictionary
                    let feed = responseData!["feed"] as? NSDictionary
                    let entries = feed!["entries"] as? NSArray
                    self.entries = entries!
                } catch _ as NSError {
                    // エラー処理をする
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
    
        })
        dataTask.resume()
    }
}

