//
//  DataController.swift
//  ToDoApp
//
//  Created by IOS DEV on 26/09/2019.
//  Copyright © 2019 IOS DEV. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataController {
    
    let persistentContainer: NSPersistentContainer!
    
    //MARK: Init with dependency
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
    }
    
    lazy var context: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    func getDataCount() -> Int {
        let request: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        do {
            return try context.count(for: request)
        } catch let error {
            print(error)
            return 0
        }
    }
    
    //MARK: CRUD
    
    func insertTodoItem(name: String) -> Tasks? {
        guard let task = NSEntityDescription.insertNewObject(forEntityName: "Tasks", into: context) as? Tasks else { return nil }
        task.taskName = name
        task.id = Int64(getDataCount())
        saveTasks { (error, tasks) in
            
        }
        return task
    }
    
    func createTask(taskName: String, completionHandler: @escaping (Error?, [Tasks]) -> Void) {
        guard let task = NSEntityDescription.insertNewObject(forEntityName: "Tasks", into: context) as? Tasks else {
            completionHandler(nil, [])
            return
        }
        task.taskName = taskName
        task.id = Int64(getDataCount())
        saveTasks { (error, tasks) in
            completionHandler(error, tasks)
        }
    }
    
    func updateTask(task: Tasks, taskName: String, checked: Bool, completionHandler: @escaping (Error?, [Tasks]) -> Void) {
        task.taskName = taskName
        task.checked = checked
        saveTasks { (error, tasks) in
            completionHandler(error, tasks)
        }
    }
    
    func removeTask(task: Tasks, completionHandler: @escaping (Error?, [Tasks]) -> Void) {
        context.delete(task)
        saveTasks { (error, tasks) in
            completionHandler(error, tasks)
        }
    }
    
    func saveTasks(completionHandler: @escaping (Error?, [Tasks]) -> Void) {
        var error: Error?
        if context.hasChanges {
            do {
                try context.save()
            } catch let err{
                error = err
            }
        }
        completionHandler(error, fetchTasks())
    }
    
    func fetchTasks() -> [Tasks] {
        let request: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? [Tasks]()
    }
}
