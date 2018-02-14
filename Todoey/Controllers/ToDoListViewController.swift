//
//  ViewController.swift
//  Todoey
//
//  Created by Vice Priborkin on 11/02/2018.
//  Copyright © 2018 Vice Priborkin. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray : [Item] = [Item]()
    
    // setting the reference to UserDefaults
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem : Item = Item()
        newItem.title = "Vice"
        itemArray.append(newItem)
        
        let newItem2 : Item = Item()
        newItem2.title = "David"
        itemArray.append(newItem2)
        
        let newItem3 : Item = Item()
        newItem3.title = "Joe"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
        }
        
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
        let item : Item = itemArray[indexPath.row]
        
        // because the itemArray is now an Item and not a String
        cell.textLabel?.text = item.title
        
        // Ternary Operator
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // short way
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //        // long way
        //        if itemArray[indexPath.row].done == false {
        //            itemArray[indexPath.row].done = true
        //        } else {
        //            itemArray[indexPath.row].done = false
        //        }
        tableView.reloadData()
        
        // change appearance of selected row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // var to save the text from popup
        var textField = UITextField()
        
        // create popup alert
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        // add text field to popup alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        // create action to alert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when the user clicks add
            let newItem : Item = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            // saving to UserDefaults
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            // reload the table view with our new items
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        // show popup
        present(alert, animated: true, completion: nil)
        
    }
    
}

