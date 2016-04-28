//
//  SearchTableViewController.swift
//  InstagramClone
//
//  Created by Joanne Lim on 22/4/16.
//  Copyright © 2016 Faris Roslan. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {
    @IBOutlet weak var searchTextField: UITextField!
    var usernameID = [User]()
    var filteredTableData = [User]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataService.dataService.USER_REF.observeEventType(.ChildAdded, withBlock:  { (snapshot) in
            if let value = snapshot.value as? [String : AnyObject]{
                let userName = User(key: snapshot.key, dict: value)
                
                self.usernameID.append(userName)
                self.usernameID.sortInPlace({ $1.self.username.lowercaseString > $0.self.username.lowercaseString })
                self.tableView.reloadData()
            }
        })
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
    }
    
    
    @IBAction func searchButtonPressed(sender: AnyObject) {
        
        
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.active) {
            return self.filteredTableData.count
        }
        else {
            return self.usernameID.count
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if (self.resultSearchController.active) {
            let user = filteredTableData[indexPath.row]
            cell.textLabel?.text = user.username
            
            return cell
            
        } else {
            let userName = self.usernameID[indexPath.row]
            cell.textLabel?.text = userName.username
            
            
            return cell
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? OtherUserProfileViewController{
            if let cell = sender as? UITableViewCell{
                let indexPath = tableView.indexPathForCell(cell)!
                
                let choosenUser = self.usernameID[indexPath.row]
                destination.user = choosenUser
            }
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        filteredTableData.removeAll(keepCapacity: false)
        
//        let searchPredicate = NSPredicate(format: "SELF.username CONTAINS[c] %@", searchController.searchBar.text!)
//        let array = (usernameID as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
//        filteredTableData = array as! [String]
        
        filteredTableData = usernameID.filter({ $0.username.lowercaseString.hasPrefix(searchController.searchBar.text!.lowercaseString) })
        self.tableView.reloadData()
        
    }
    
    
}
