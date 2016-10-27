//
//  MasterViewController.swift
//  MathQuiz For Third Standard
//
//  Created by  jyotishankar sahoo on 7/12/16.
//  Copyright © 2016  jyotishankar sahoo. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var chapterList = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        let frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 44.0)
        let titleLabel = UILabel.init(frame: frame)
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.font = UIFont.init(name: "Chalkduster", size: 24.0)
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.text = "Chapters"
        self.navigationItem.titleView = titleLabel
        
        self.chapterList = ["Numbers", "Addition", "Subtraction", "Multiplication", "Division", "Mixed", "Logical Reasoning", "Money", "Time", "Geometry"]
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let chapterController = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                chapterController.detailItem = self.chapterList[indexPath.row]
                chapterController.navigationItem.title = self.chapterList[indexPath.row]
                chapterController.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                chapterController.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chapterList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = self.chapterList[indexPath.row]
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65.0;
    }

}

