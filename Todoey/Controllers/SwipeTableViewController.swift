//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Donavon on 7/26/18.
//  Copyright © 2018 Donavon Buchanan. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Change cell height for all inherited cells
        tableView.rowHeight = 80.0
        
        //Add a footer view to hide extra cells
        self.tableView.tableFooterView = UIView()
        
        //remove cell separators for all inherited cells
        self.tableView.separatorStyle = .none
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func updateNavBar(withHexCode colorHexCode: String) {guard let navController = navigationController else {
        fatalError()
        }
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else {fatalError()}
        
        navController.navigationBar.barTintColor = navBarColor
        navController.navigationBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navController.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        tableView.backgroundColor = navBarColor
        self.navigationController?.hidesNavigationBarHairline = true
        self.navigationController?.setStatusBarStyle(UIStatusBarStyleContrast)
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        //SwipeTableViewCell delegate
        cell.delegate = self
        
        return cell
    }

    //MARK: - Swipe Cell Delegate Methods
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil}
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // handle action by updating model with deletion
            self.updateModel(at: indexPath)

            //tableView.reloadData()
            //editActionsOptionsForRowAt takes care of the table reload
        }
        
        //customize the action appearance
        //deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    //continue dragging to delete
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        //Update data model
    }

}
