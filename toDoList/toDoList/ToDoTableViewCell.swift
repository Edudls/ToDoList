//
//  ToDoTableViewCell.swift
//  toDoList
//
//  Created by C02GC0VZDRJL on 12/3/18.
//  Copyright © 2018 Daniel Monaghan. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var taskDescLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.layoutIfNeeded()
    }
    
}
