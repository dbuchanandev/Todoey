//
//  SearchBarDelegate.swift
//  Todoey
//
//  Created by Donavon on 7/18/18.
//  Copyright © 2018 Donavon Buchanan. All rights reserved.
//

import UIKit
import RealmSwift

extension TodoListViewController: UISearchBarDelegate {
    
    func performSearch(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {
            //load all items if search is empty
            loadItems()
        } else {
            //filter by title matching search text. Sort by date created
            // Still call loadItems() first so that the filter is set again as characters are removed from search
            loadItems()
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            //Still have to tell the table to reload
            tableView.reloadData()
        }
    }
    
    //MARK: - Search bar methods
    
    //Some of this might be a little redundant
    /*
     User experience could be better by changing the search button to a Done or Cancel
     when searchBar.text?.count == 0 instead of automatically dismissing the keyboard
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch(searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //ideally the search has already completed via textDidChange
        //dismiss the keyboard
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //dismiss the keyboard
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        //reload all items
        loadItems()
    }
    
}
