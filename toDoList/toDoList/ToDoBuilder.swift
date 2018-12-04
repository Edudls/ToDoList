//
//  taskBuilder.swift
//  toDoList
//
//  Created by C02GC0VZDRJL on 12/3/18.
//  Copyright © 2018 Daniel Monaghan. All rights reserved.
//

import Foundation

protocol ToDoBuilder {
    func createTask(titleText: String, taskDesc: String, dueDate: Date)
}
