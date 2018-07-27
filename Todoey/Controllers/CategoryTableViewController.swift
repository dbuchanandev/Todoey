//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Donavon on 7/18/18.
//  Copyright © 2018 Donavon Buchanan. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    let originalColorHex = FlatSkyBlue().hexValue()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        loadCategories()
        
        updateNavBar(withHexCode: originalColorHex)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //updateNavBar(withHexCode: originalColorHex)
        self.navigationController?.hidesNavigationBarHairline = true
        self.setStatusBarStyle(UIStatusBarStyleContrast)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Nav Bar Update Methods
    func updateNavBar(withHexCode colorHexCode: String) {
        guard let navController = navigationController else {
            fatalError()
        }
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else {fatalError()}
        
        navController.navigationBar.barTintColor = navBarColor
        navController.navigationBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navController.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        tableView.backgroundColor = navBarColor
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return categories?.count ?? 1
    }

    //MARK: TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            guard let categoryColor = UIColor(hexString: category.hexColor) else {fatalError()}
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }

        return cell
    }

//    //Swipe to delete
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return .delete
//    }
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            if let item = categories?[indexPath.row] {
//                do {
//                    try realm.write {
//                        realm.delete(item)
//                    }
//                } catch {
//                    print("Error deleting category: \(error)")
//                }
//            }
//            
//            tableView.reloadData()
//        }
//    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        addNewCategory()
        
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //If no category exist and a row is tapped, show alert to add a new category
        //else, segue to the selected category list
        if categories?.count == 0 {
            addNewCategory()
        } else {
            performSegue(withIdentifier: "goToItems", sender: self)
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
//            self.navigationController?.navigationBar.barTintColor = UIColor(hexString: (categories?[indexPath.row].hexColor)!)
        }
        
    }
    
    //MARK: Data Manipulation Methods
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving categories: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {

        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    //Override empty delete func from super
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        if let category = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category)
                }
            } catch {
                print("Error deleting category: \(error)")
            }
        }
    }
    
    func addNewCategory() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //what will happen once the user taps add item button on UIAlert
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.hexColor = UIColor(randomFlatColorOf:.light).hexValue()
            
            self.save(category: newCategory)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
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
