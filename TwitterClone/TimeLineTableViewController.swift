//
//  TimeLineTableViewController.swift
//  TwitterClone
//
//  Created by Shoya Ishimaru on 2015/05/08.
//  Copyright (c) 2015年 shoya140. All rights reserved.
//

import UIKit

class TimeLineTableViewController: UITableViewController {

    var currentUser: PFUser?
    var items: Array<PFObject> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("updateTimeLine"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        currentUser = PFUser.currentUser()
        if let currentUser = currentUser {
            self.navigationItem.title = currentUser.username
            self.updateTimeLine()
        } else {
            self.login()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func logoutButtonTapped(sender: AnyObject) {
        PFUser.logOut()
        self.login()
    }
    
    @IBAction func tweetButtonTapped(sender: AnyObject) {
        var alert = UIAlertController(title: "新しい投稿", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:{
            (action:UIAlertAction!) -> Void in
        })
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
            (action: UIAlertAction!) -> Void in
            let textFields: Array<UITextField>? = alert.textFields as! Array<UITextField>?
            if let textFields = textFields {
                let textField = textFields[0]
                if count(textField.text) == 0 {
                    return
                }
                var tweet = PFObject(className:"Tweet")
                tweet["text"] = textField.text
                tweet["parent"] = self.currentUser!
                tweet.saveInBackgroundWithBlock({
                    (succeed: Bool, error: NSError?) -> Void in
                    self.updateTimeLine()
                })
            }
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func updateTimeLine() {
        var query = PFQuery(className:"Tweet")
        query.whereKey("parent", equalTo:currentUser!)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error != nil {
                println("error: \(error!.userInfo)")
                return
            }
            self.items = objects as! Array<PFObject>
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    func login() {
        let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        self.presentViewController(loginVC, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count(self.items)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        let tweet = self.items[indexPath.row]
        cell.textLabel!.text = tweet["text"] as? String
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
