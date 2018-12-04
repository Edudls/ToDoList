//
//  Completed.swift
//  toDoList
//
//  Created by C02GC0VZDRJL on 12/1/18.
//  Copyright © 2018 Daniel Monaghan. All rights reserved.
//

import UIKit

class ToDoViewController: UIViewController {
    
    let REUSE_IDENTIFIER = "ToDoTaskCell"
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTaskButton: UIBarButtonItem!
    
    var tasks = [ToDoTask]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let nib = UINib(nibName: "ToDoTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: REUSE_IDENTIFIER)
        
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        //self.tableView.estimatedRowHeight = 120.0
        self.tableView.rowHeight = 120.0
        
        self.loadArchivedTasks()
        
        self.title = "To-Do List"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTasks()
    }
    /* for reference
    @IBAction func addPizzaAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPizzaViewController") as! AddPizzaViewController
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    */
    
    @IBAction func addNewTaskAction(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func loadArchivedTasks() {
        DispatchQueue.global().async { [unowned self] in
            self.tasks = ToDoTask.loadSavedTasks()
            DispatchQueue.main.async { [unowned self] in
                self.tableView.reloadData()
            }
        }
    }
    
    func loadTasks() {
        DispatchQueue.global().async {
            let filePath = Bundle.main.path(forResource: "tasks", ofType: "json")
            let url = URL.init(fileURLWithPath: filePath!)
            
            do {
                let taskData = try Data.init(contentsOf: url)
                let taskJSON = try JSONSerialization.jsonObject(with: taskData, options: .mutableLeaves) as! [[String:Any]]
                
                for task in taskJSON {
                    var titleText: String
                    var taskDesc: String
                    var dueDate: Date
                    
                    titleText = task["titleText"] as! String
                    taskDesc = task["taskDesc"] as! String
                    dueDate = task["dueDate"] as! Date
                    
                    let newTask = ToDoTask(titleText: titleText, taskDesc: taskDesc, dueDate: dueDate)
                    
                    self.tasks.append(newTask)
                }
            }
            catch {
                print("\(error)")
                return
            }
            DispatchQueue.main.async { [unowned self] in
                self.tableView.reloadData()
            }
        }
    }
}

extension ToDoViewController: UITableViewDataSource {
    
    /* for reference
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_todo", for: indexPath)
        
        if indexPath.row < toDoItems.count {
            let item = toDoItems[indexPath.row]
            cell.textLabel?.text = item.title
            
            let accessory: UITableViewCellAccessoryType = item.done ? .checkmark : .none
            cell.accessoryType = accessory
        }
        
        return cell
    }*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: REUSE_IDENTIFIER, for: indexPath) as! ToDoTableViewCell
        
        let task = tasks[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        
        cell.titleTextLabel.text = task.titleText
        cell.taskDescLabel.text = task.taskDesc
        cell.dueDateLabel.text = formatter.string(from: task.dueDate)
        
        let now = Date()
        
        if task.dueDate < now {
            cell.dueDateLabel.textColor = UIColor.red
        } else {
            cell.dueDateLabel.textColor = UIColor.black
        }
        
        let accessory: UITableViewCellAccessoryType = task.done ? .checkmark : .none
        cell.accessoryType = accessory
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if indexPath.row < tasks.count {
            
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
        }
    }
    
}

extension ToDoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < tasks.count {
            
            let item = tasks[indexPath.row]
            item.done = !item.done
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        ToDoTask.saveTasks(self.tasks)
        self.tableView.reloadData()
        
    }
}

extension ToDoViewController: ToDoBuilder{
    func createTask(titleText: String, taskDesc: String, dueDate: Date){
        let newTask = ToDoTask(titleText: titleText, taskDesc: taskDesc, dueDate: dueDate)
        self.tasks.append(newTask)
        ToDoTask.saveTasks(self.tasks)
        self.tableView.reloadData()
    }
}

