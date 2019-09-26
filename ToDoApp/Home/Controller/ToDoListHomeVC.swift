//
//  ToDoListHomeVc.swift
//  ToDoApp
//
//  Created by IOS DEV on 25/09/2019.
//  Copyright © 2019 IOS DEV. All rights reserved.
//

import UIKit
import CoreData

class ToDoListHomeVC: UIViewController {
    
    @IBOutlet weak var tasksTableView: UITableView!
    
    var tasks = [Tasks]()
    var selectedTask: Tasks!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasksTableView.register(UINib(nibName: TVCIdentifiers.TasksTVCIdentifier, bundle: nil), forCellReuseIdentifier: TVCIdentifiers.TasksTVCIdentifier)
        
        fetchTasks()
    }
    
    @IBAction func addNewTaskAction(_ sender: UIBarButtonItem) {
        selectedTask = nil
        self.performSegue(withIdentifier: SegueIdentifiers.AddTaskSegueIdentifier, sender: self)
    }
    
    
    func fetchTasks() {
        tasks = DataController().fetchTasks()
        tasksTableView.reloadData()
    }
    
    func parseAndLoadData(error: Error?, tasks: [Tasks]) {
        self.tasks = tasks
        tasksTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.AddTaskSegueIdentifier {
            let destVC = segue.destination as! AddTaskController
            if selectedTask != nil {
                destVC.taskName = selectedTask.taskName ?? ""
                destVC.taskId = Int(selectedTask.id)
                destVC.taskChecked = selectedTask.checked
            }
            destVC.delegate = self
        }
    }
}

extension ToDoListHomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TVCIdentifiers.TasksTVCIdentifier) as! TasksTVC
        cell.taskNameLabel.text = tasks[indexPath.row].taskName
        
        if tasks[indexPath.row].checked {
            cell.checkBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBoxFILLED "), for: .normal)
        } else {
            cell.checkBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBoxOUTLINE "), for:.normal)
        }
        
        cell.delegate = self
        cell.tasks = tasks
        cell.indexPathRow = indexPath.row
        return cell
    }
}

extension ToDoListHomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTask = tasks[indexPath.row]
        self.performSegue(withIdentifier: SegueIdentifiers.AddTaskSegueIdentifier, sender: self)
    }
}

extension ToDoListHomeVC: CheckBoxDelegate {
    
    func deleteTask(index: Int?) {
        guard let index = index else {
            return
        }
        let task = tasks[index]
        let alertcontroller = UIAlertController(title: "", message: "Are you sure you want to delete the task \(task.taskName ?? "task name")", preferredStyle: .alert)
        alertcontroller.addAction(UIAlertAction(title: "Delete", style: .default, handler: { [weak self] action in
            guard let strongSelf = self else {
                return
            }
            DataController().removeTask(task: task, completionHandler: { [weak strongSelf] (error, tasks) in
                guard let strongSelf = strongSelf else {
                    return
                }
                strongSelf.parseAndLoadData(error: error, tasks: tasks)
            })
        }))
        alertcontroller.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(alertcontroller, animated: true, completion: nil)
    }
    
    func checkBox(state: Bool, index: Int?) {
        guard let index = index else {
            return
        }
        let task = tasks[index]
        DataController().updateTask(task: task, taskName: task.taskName ?? "", checked: state) { [weak self] (error, tasks) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.parseAndLoadData(error: error, tasks: tasks)
        }
        
    }
}

extension ToDoListHomeVC: AddTaskDelegate {
    
    func addTask(name: String, taskId: Int, taskChecked: Bool) {
        if taskId != 0 {
            guard let task = selectedTask else {
                return
            }
            DataController().updateTask(task: task, taskName: name, checked: task.checked) { [weak self] (error, tasks) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.parseAndLoadData(error: error, tasks: tasks)
            }
        } else {
            DataController().createTask(taskName: name) { [weak self] (error, tasks) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.parseAndLoadData(error: error, tasks: tasks)
            }
        }
    }
}
