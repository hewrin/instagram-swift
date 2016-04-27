//
//  SearchTableViewController.swift
//  InstagramClone
//
//  Created by Joanne Lim on 22/4/16.
//  Copyright © 2016 Faris Roslan. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    @IBOutlet weak var searchTextField: UITextField!
    var usernameID = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataService.dataService.USER_REF.observeEventType(.ChildAdded, withBlock:  { (snapshot) in
            if let value = snapshot.value as? [String : AnyObject]{
                let userName = User(key: snapshot.key, dict: value)
                
                self.usernameID.append(userName)
                self.usernameID.sortInPlace({$1.self.username < $0.self.username})
                self.tableView.reloadData()
            }
        })

        
    }

    
    @IBAction func searchButtonPressed(sender: AnyObject) {
        
        
        
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        
        return usernameID.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        let userName = self.usernameID[indexPath.row]
        cell.textLabel?.text = userName.username
        

        return cell
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
    

}
