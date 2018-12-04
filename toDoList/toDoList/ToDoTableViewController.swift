//
//  ToDoList.swift
//  toDoList
//
//  Created by C02GC0VZDRJL on 12/1/18.
//  Copyright © 2018 Daniel Monaghan. All rights reserved.
//
/*
import UIKit

//MARK: to do task model
class ToDoList: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //adds a title to the nav bar
        self.title = "To-Do"
        
        //adds a "+" button to the nav bar for adding new items. note that the class name is directly referenced here.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ToDoList.didTapAddItemButton(_:)))
        
        
        // Setup a notification to let us know when the app is about to close,
        // and that we should store the user items to persistence. This will call the
        // applicationDidEnterBackground() function in this class
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)),
            name: NSNotification.Name.UIApplicationDidEnterBackground,
            object: nil)
        
        do
        {
            // Try to load from persistence
            self.toDoItems = try [ToDoItem].readFromPersistence()
        }
        catch let error as NSError
        {
            if error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoSuchFileError
            {
                NSLog("No persistence file found, not necesserially an error...")
            }
            else
            {
                let alert = UIAlertController(
                    title: "Error",
                    message: "Could not load the to-do items!",
                    preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
                NSLog("Error loading from persistence: \(error)")
            }
        }
    }
    
    
    //gets placeholder data
    private var toDoItems = [ToDoItem]()
    
    //sets the number of sections in each row
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //gets the number of items in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    //adds stored data from ToDoTable to the cells in the tableview
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_todo", for: indexPath)
        
        if indexPath.row < toDoItems.count {
            let item = toDoItems[indexPath.row]
            cell.textLabel?.text = item.title
            
            let accessory: UITableViewCellAccessoryType = item.done ? .checkmark : .none
            cell.accessoryType = accessory
        }
        
        return cell
    }
    
    //adds the ability to checkmark when a task is done by tapping, and auto-deselects the tapped row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < toDoItems.count {
            
            let item = toDoItems[indexPath.row]
            item.done = !item.done
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    //creates the alert that will pop up to add new items
    func didTapAddItemButton(_ sender: UIBarButtonItem) {
        // Create an alert
        let alert = UIAlertController(
            title: "New to-do item",
            message: "Insert the title of the new to-do item:",
            preferredStyle: .alert)
        
        // Add a text field to the alert for the new item's title
        alert.addTextField(configurationHandler: nil)
        
        // Add a "cancel" button to the alert. This one doesn't need a handler
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Add a "OK" button to the alert. The handler calls addNewToDoItem()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            
            if let title = alert.textFields?[0].text {
                self.addNewToDoItem(title: title)
            }
        }))
        
        // Present the alert to the user
        self.present(alert, animated: true, completion: nil)
    }
    
    //creates the actual function to add the item from the above alert to the table
    private func addNewToDoItem(title: String) {
        
        // The index of the new item will be the current item count
        let newIndex = toDoItems.count
        
        // Create new item and add it to the todo items list
        toDoItems.append(ToDoItem(title: title))
        
        // Tell the table view a new row has been created
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .top)
    }
    
    //enables built-in function for swiping to remove table items
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if indexPath.row < toDoItems.count {
            
            toDoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
        }
    }
    
    //this is very inconsistent about actually saving the data like it's supposed to since it only seems to trigger on home button press, which is why i added the pizza model below for reference since that encoding/decoding actually worked
    @objc
    public func applicationDidEnterBackground(_ notification: NSNotification) {
        do {
            try toDoItems.writeToPersistence()
        } catch let error {
            NSLog("Error writing to persistence: \(error)")
        }
    }
}


//MARK: pizza model
/* all of the relevant methods from the pizza code, placed here for convenient reference
class Pizza: NSObject, NSCoding {
    
    // MARK: Persistence Directory
    
    static var FileDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let FilePath: URL = Pizza.FileDirectory.appendingPathComponent("savedPizzas")
    
    
    // MARK: Properties
    
    var toppings: [String]
    var price: Int
    var isFavorite: Bool = false
    
    var allToppings: String {
        get {
            return toppings.joined(separator: "\n")
        }
    }
    
    init(toppings: [String], price: Int) {
        self.toppings = toppings
        self.price = price
    }
    
    init(toppings: [String]?, price: Int?) {
        self.toppings = toppings != nil ? toppings! : []
        self.price = price != nil ? price! : randomNum(10)
    }
    
    // MARK: NSCoding
    
    struct CodingKeys {
        static let toppings = "toppings"
        static let price = "price"
        static let isFavorite = "isFavorite"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.toppings, forKey: CodingKeys.toppings)
        aCoder.encode(self.price, forKey: CodingKeys.price)
        aCoder.encode(self.isFavorite, forKey: CodingKeys.isFavorite)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.toppings = aDecoder.decodeObject(forKey: CodingKeys.toppings) as! [String]
        self.price = aDecoder.decodeInteger(forKey: CodingKeys.price)
        self.isFavorite = aDecoder.decodeBool(forKey: CodingKeys.isFavorite)
    }
}

// MARK: Convenience Methods

extension Pizza {
    func toggleFavorite() {
        self.isFavorite = !self.isFavorite
    }
}

// MARK: Persistence Methods, NSKeyedArchiver

extension Pizza {
    static func savePizzas(_ pizzas: [Pizza]) {
        let pizzaData = NSKeyedArchiver.archivedData(withRootObject: pizzas)
        
        do {
            try pizzaData.write(to: Pizza.FilePath)
        }
        catch {
            print("Could not write data")
        }
    }
    
    static func loadSavedPizzas() -> [Pizza] {
        guard let savedData = NSData(contentsOf: Pizza.FilePath) else {
            print("No saved data")
            return []
        }
        do {
            let pizzas = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as! [Pizza]
            return pizzas
        }
        catch {
            print("Error found while unarchiving: \(error)")
            return []
        }
    }
    
}
*/


*/


