//
//  ViewController.swift
//  Todoey
//
//  Created by Vice Priborkin on 11/02/2018.
//  Copyright © 2018 Vice Priborkin. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm : Realm = try! Realm()
    
    var toDoItems : Results<Item>?
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let colorHex = selectedCategory?.color {
            title = selectedCategory!.name
            
            if let navBar = navigationController?.navigationBar {
                if let navBarColor = UIColor(hexString: colorHex) {
                navBar.barTintColor = UIColor(hexString: colorHex)
                    navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                    
                    navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
                    
                    searchBar.barTintColor = navBarColor
                }
            }
        }
    }
    //MARK: - Tableview Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item : Item = toDoItems?[indexPath.row]{
            //because the itemArray is now an Item and not a String
            cell.textLabel?.text = item.title
            //Ternary Operator - short way
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        } else {
            cell.textLabel?.text = "NO Items Added"
        }
        
        return cell
    }
    
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error updating item: \(error)")
            }
        }
        tableView.reloadData()
        
        //change appearance of selected row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //var to save text from popup
        var textField = UITextField()
        
        //create popup alert
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //add text field to popup alert
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        //create action to alert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user clicks add
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving item: \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        //show popup
        present(alert, animated: true, completion: nil)
    }
    //MARK: - An exapmle of deleting with Swype
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //
    //            if let itemForDeletion = self.toDoItems?[indexPath.row]{
    //                do {
    //                    try self.realm.write {
    //                        self.realm.delete(itemForDeletion)
    //                    }
    //                } catch {
    //                    print("Error deleting Item: \(error)")
    //                }
    //
    //
    //                self.tableView.reloadData()
    //            }
    //        }
    //    }
    
    
    //MARK: - Model manipulation Methods
    
    func loadItems(){
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting Item :\(error)")
            }
        }
    }
}

//MARK: - SearchBar Delegate Methods
extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count != 0 {
            toDoItems = toDoItems?.filter("title CONTAINS[cd] %@" , searchBar.text!).sorted(byKeyPath: "dateCreated" , ascending: false)
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            loadItems()
        }
        
        
        //        //you can do this here and than the array will be updated all the time so U see it automatically.
        //        if searchBar.text?.count != 0 {
        //            let request : NSFetchRequest<Item> = Item.fetchRequest()
        //
        //            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //
        //            //sortDescriptors - plural - it wants an array of sortDescriptors but we only have one so we have only one so we wrap it in an array
        //            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        //
        //            loadItems(with: request)
        //        }
    }
    
}


























