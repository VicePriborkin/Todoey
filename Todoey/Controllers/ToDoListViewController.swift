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
    //let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("MyData.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        
//        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//        print(path!)
//        
//        let newItem : Item = Item()
//        newItem.title = "Vice"
//        itemArray.append(newItem)
//        
//        let newItem2 : Item = Item()
//        newItem2.title = "David"
//        itemArray.append(newItem2)
//        
//        let newItem3 : Item = Item()
//        newItem3.title = "Joe"
//        itemArray.append(newItem3)
//        
        loadItems()
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
        
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
        
        saveItems()
        
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
            
            self.saveItems()
            
            // saving to UserDefaults
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            // reload the table view with our new items
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        // show popup
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItems(){
        //create an encoder
        let encoder : PropertyListEncoder = PropertyListEncoder()
        do {
            // encoding the data
            let data = try encoder.encode(itemArray)
            // writing our data custom file
            try data.write(to: dataFilePath!)
        } catch {
            print("Error saving Item Array: \(error)")
        }
    }
    
    func loadItems(){
        do {
            let data = try Data(contentsOf: dataFilePath!)
            let decoder : PropertyListDecoder = PropertyListDecoder()
            
            //this is the method that decodes our data. We have to specify what is the data type of the decoded value. Our data is an Array of Items - [Item]. We have to add the .self so it will know that we are reffering to our Item type and not an object.
        
            itemArray = try decoder.decode([Item].self, from: data)
        } catch {
            print("Error decoding Item Array: \(error)")
        }
        
//        //Another way of TRY & CATCH for decoding the Data. In case that try? will receive an error, it will return nil witout any exception. We will usually use this syntax when we do not care on what error we receive.
//
//        if let dataTwo = try? Data(contentsOf: dataFilePath!){
//            let decoderTwo : PropertyListDecoder = PropertyListDecoder()
//            do {
//                itemArray = try decoderTwo.decode([Item].self, from: dataTwo)
//            } catch {
//                print("Error decoding Item Array: \(error)")
//            }
//        }
    }
    
    
}

