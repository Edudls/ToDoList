//
//  AddTaskViewController.swift
//  toDoList
//
//  Created by C02GC0VZDRJL on 12/2/18.
//  Copyright © 2018 Daniel Monaghan. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var taskDescTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    var titleText: String = ""
    var taskDesc: String = ""
    var dueDate: Date = Date()
    
    var delegate: ToDoBuilder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "New Task"
    }
    
    @IBAction func submitTaskButton(_ sender: Any) {
        self.titleText = self.titleTextField.text!
        self.taskDesc = self.taskDescTextField.text!
        self.dueDate = self.dueDatePicker.date
        print(self.titleText)
        print(self.taskDesc)
        print(self.dueDate)
        self.delegate?.createTask(titleText: titleText, taskDesc: taskDesc, dueDate: dueDate as Date)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
