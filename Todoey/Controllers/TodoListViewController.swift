//
//  ViewController.swift
//  Todoey
//
//  Created by Donavon on 7/14/18.
//  Copyright © 2018 Donavon Buchanan. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {

    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Add a footer view to hide extra cells
        self.tableView.tableFooterView = UIView()
        //set nav bar title to match selected category
        self.navigationBar.title = selectedCategory?.name
    }
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            //If nil, "No Categories Added Yet"
            cell.textLabel?.text = todoItems?[indexPath.row].title ?? "No Items Added Yet"
            
            //Ternary operator
            cell.accessoryType = item.done ? .checkmark : .none
            
            //set strikethrough and change the color to grey if the item is done
            if item.done {
                cell.textLabel?.attributedText = NSAttributedString(string: item.title, attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray, NSAttributedStringKey.strikethroughStyle: 1])
            } else {
                // would be better to set a global variable for color to use here
                cell.textLabel?.attributedText = NSAttributedString(string: item.title, attributes: [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.strikethroughStyle: 0])
            }
        }
        

        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //If no items exist and a row is tapped, show alert to add new items
        //else, modify the done status of the selected item
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status: \(error)")
            }
        }
        
        tableView.reloadData()
        
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        addNewItem()
        
    }
    
    //MARK: - Model Manipulation Methods
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    //Swipe to delete
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        if let item = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("Error deleting item: \(error)")
            }
        }
    }
    
    func addNewItem() {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user taps add item button on UIAlert
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items: \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        //needs cancel button too
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (cancelAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
    }

}

//MARK: - Search Bar Delegate Methods

extension TodoListViewController: UISearchBarDelegate {
    
    func performSearch(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {
            //load all items if search is empty
            loadItems()
        } else {
            //filter by title matching search text. Sort by date created
            // Still call loadItems() first so that the filter is set again as characters are removed from search
            loadItems()
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
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



