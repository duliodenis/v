//
//  ContactsSearchResultsController.swift
//  V
//
//  Created by Dulio Denis on 7/20/16.
//  Copyright © 2016 Dulio Denis. All rights reserved.
//

import UIKit
import CoreData

class ContactsSearchResultsController: UITableViewController {
    
    private var filteredContacts = [Contact]()
    
    var contacts = [Contact]() {
        // every time we update contacts
        // we'll also update the filteredContacts
        didSet {
            filteredContacts = contacts
        }
    }
    
    private let cellIdentifier = "ContactsSearchCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    */

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContacts.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)

        let contact = filteredContacts[indexPath.row]
        cell.textLabel?.text = contact.fullName

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let contact = filteredContacts[indexPath.row]
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ContactsSearchResultsController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        // when the search bar becomes active lets make sure we have some search text
        guard let searchText = searchController.searchBar.text else { return }
        // confirm that we have some characters
        if searchText.characters.count > 0 {
            // update the filtered contacts array by calling the filter method on the contacts arrary
            filteredContacts = contacts.filter {
                // iterate and use range of string to see if we have a match with the search string
                $0.fullName.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            }
        } else {
            // update filtered contacts with contacts if there are no characters in the search text
            filteredContacts = contacts
        }
        // reload the tableView
        tableView.reloadData()
    }
    
}
