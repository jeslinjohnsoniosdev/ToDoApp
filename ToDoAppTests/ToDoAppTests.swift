//
//  ToDoAppTests.swift
//  ToDoAppTests
//
//  Created by IOS DEV on 25/09/2019.
//  Copyright © 2019 IOS DEV. All rights reserved.
//

import XCTest
import CoreData
@testable import ToDoApp

class ToDoAppTests: XCTestCase {
    
    var sut: DataController!
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ToDoApp", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition( description.type == NSInMemoryStoreType )
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    func initStubs() {
        
        func insertTodoItem( name: String, id: Int ) {
            let context = mockPersistantContainer.viewContext
            let task = NSEntityDescription.insertNewObject(forEntityName: "Tasks", into: context)
            
            task.setValue(name, forKey: "taskName")
            task.setValue(id, forKey: "id")
        }
        
        insertTodoItem(name: "1", id: 1)
        insertTodoItem(name: "2", id: 2)
        insertTodoItem(name: "3", id: 3)
        insertTodoItem(name: "4", id: 4)
        insertTodoItem(name: "5", id: 5)
        
        do {
            try mockPersistantContainer.viewContext.save()
        }  catch {
            print("create fakes error \(error)")
        }
        
    }
    
    func flushData() {
        let tasks = sut.fetchTasks()
        let context = mockPersistantContainer.viewContext
        for task in tasks {
            context.delete(task)
        }
        try! mockPersistantContainer.viewContext.save()
        
    }

    override func setUp() {
        super.setUp()
        initStubs()
        sut = DataController(container: mockPersistantContainer)
    }

    override func tearDown() {
        flushData()
        super.tearDown()
    }

    func test_create_todo() {
        let todo = sut.insertTodoItem(name: "test")
        XCTAssertNotNil( todo )
    }
    
    func test_fetch_all_todo() {
        let results = sut.fetchTasks()
        XCTAssertEqual(results.count, 5)
        
    }
    
    func test_remove_todo() {
        let items = sut.fetchTasks()
        let item = items[0]

        let numberOfItems = items.count
        sut.removeTask(task: item) { (error, tasks) in
            XCTAssertEqual(self.numberOfItemsInPersistentStore(), numberOfItems - 1)
        }
    }
    
    func numberOfItemsInPersistentStore() -> Int {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Tasks")
        let results = try! mockPersistantContainer.viewContext.fetch(request)
        return results.count
    }

}
