//
//  SearchBarDelegate.swift
//  Todoey
//
//  Created by Donavon on 7/18/18.
//  Copyright © 2018 Donavon Buchanan. All rights reserved.
//

import UIKit
import CoreData

extension TodoListViewController: UISearchBarDelegate {
    
    func performSearch(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
        if searchBar.text?.count == 0 {
            loadItems()
        }
    }
    
    //MARK: - Search bar methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch(searchBar)
        //doesn't work as expected. Lol
//        if searchBar.text?.count == 0 {
//            DispatchQueue.main.async {
//                searchBar.returnKeyType = .done
//            }
//        } else {
//            DispatchQueue.main.async {
//                searchBar.returnKeyType = .search
//            }
//        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
