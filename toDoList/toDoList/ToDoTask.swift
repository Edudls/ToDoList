//
//  ToDoTask.swift
//  toDoList
//
//  Created by C02GC0VZDRJL on 12/2/18.
//  Copyright © 2018 Daniel Monaghan. All rights reserved.
//

import Foundation

class ToDoTask: NSObject, NSCoding {
    //NSObject and NSCoding are necessary for retaining local data over multiple uses of the app
    
    static var FileDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let FilePath: URL = ToDoTask.FileDirectory.appendingPathComponent("savedTasks")
    
    //sets up and initiates the values that will be used in the table
    var titleText: String
    var taskDesc: String
    var dueDate: Date
    var done: Bool
    public init (titleText: String, taskDesc: String, dueDate: Date) {
        self.titleText = titleText
        self.taskDesc = taskDesc
        self.dueDate = dueDate
        self.done = false
    }
    
    //required methods for implementing NSCoding
    required init? (coder aDecoder: NSCoder) {
        // Try to unserialize the "title", "taskDesc", and "dueDate" variables
        if let titleText = aDecoder.decodeObject (forKey: "titleText") as? String {
            self.titleText = titleText
        } else {
            // There were no objects encoded with the key "title",
            // so that's an error.
            return nil
        }
        if let taskDesc = aDecoder.decodeObject (forKey: "taskDesc") as? String {
            self.taskDesc = taskDesc
        } else {
            // There were no objects encoded with the key "taskDesc", so error
            return nil
        }
        if let dueDate = aDecoder.decodeObject (forKey: "dueDate") as? Date {
            self.dueDate = dueDate
        } else {
            // There were no objects encoded with the key "dueDate", so error
            return nil
        }
        // Check if the key "done" exists, since decodeBool() always succeeds
        if aDecoder.containsValue (forKey: "done") {
            self.done = aDecoder.decodeBool (forKey: "done")
        } else {
            // Same problem as above
            return nil
        }
    }
    
    func encode (with aCoder: NSCoder) {
        // Store the objects into the coder object
        aCoder.encode(self.titleText, forKey: "titleText")
        aCoder.encode(self.taskDesc, forKey: "taskDesc")
        aCoder.encode(self.dueDate, forKey: "dueDate")
        aCoder.encode(self.done, forKey: "done")
    }
    
}

extension ToDoTask {
    static func saveTasks(_ tasks: [ToDoTask]) {
        let taskData = NSKeyedArchiver.archivedData(withRootObject: tasks)
        
        do {
            try taskData.write(to: ToDoTask.FilePath)
        }
        catch {
            print("Could not write data")
        }
    }
    
    static func loadSavedTasks() -> [ToDoTask] {
        guard let savedData = NSData(contentsOf: ToDoTask.FilePath) else {
            print("No saved data")
            return []
        }
        do {
            let tasks = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as! [ToDoTask]
            return tasks
        }
        catch {
            print("Error found while unarchiving: \(error)")
            return []
        }
    }
}

//i like the method used in BigPizza better, but i decided to leave this appended in case i changed my mind

/*
// Creates an extension of the Collection type (aka an Array),
// but only if it is an array of ToDoTask objects.
extension Collection where Iterator.Element == ToDoTask {
    
    // Builds the persistence URL. This is a location inside
    // the "Application Support" directory for the App.
    private static func persistencePath() -> URL? {
        
        let url = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true)
        
        return url?.appendingPathComponent("todotasks.bin")
    }
    
    // Write the array to persistence
    func writeToPersistence() throws {
        if let url = Self.persistencePath(), let array = self as? NSArray
        {
            let data = NSKeyedArchiver.archivedData(withRootObject: array)
            try data.write(to: url)
        }
        else
        {
            throw NSError(domain: "com.example.toDoList", code: 10, userInfo: nil)
        }
    }
    
    // Read the array from persistence
    static func readFromPersistence() throws -> [ToDoTask]
    {
        if let url = persistencePath(), let data = (try Data(contentsOf: url) as Data?)
        {
            if let array = NSKeyedUnarchiver.unarchiveObject(with: data) as? [ToDoTask]
            {
                return array
            }
            else
            {
                throw NSError(domain: "com.example.toDoList", code: 11, userInfo: nil)
            }
        }
        else
        {
            throw NSError(domain: "com.example.toDoList", code: 12, userInfo: nil)
        }
    }
}*/
