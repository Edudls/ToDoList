//
//  CompletedViewController.swift
//  toDoList
//
//  Created by C02GC0VZDRJL on 12/3/18.
//  Copyright © 2018 Daniel Monaghan. All rights reserved.
//

import UIKit

class CompletedViewController: UIViewController {
    
    let REUSE_IDENTIFIER = "ToDoTaskCell"
    
    var allTasks = [ToDoTask]()
    var completed = [ToDoTask]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let nib = UINib(nibName: "ToDoTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: REUSE_IDENTIFIER)
        
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        //self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = 120.0
        
        self.title = "Completed Tasks"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTasks()
    }
    
    func loadTasks() {
        self.allTasks = ToDoTask.loadSavedTasks()
        self.completed = self.allTasks.filter {
            $0.done == true
        }
        self.tableView.reloadData()
    }
}

extension CompletedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.completed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task = completed[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: REUSE_IDENTIFIER, for: indexPath) as! ToDoTableViewCell
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        
        cell.titleTextLabel.text = task.titleText
        cell.taskDescLabel.text = task.taskDesc
        cell.dueDateLabel.text = formatter.string(from: task.dueDate)
        
        return cell
    }
    
}

extension CompletedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = self.completed[indexPath.row]
        task.done = !task.done
        ToDoTask.saveTasks(self.allTasks)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}
