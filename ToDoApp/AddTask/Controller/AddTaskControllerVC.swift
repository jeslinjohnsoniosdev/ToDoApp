//
//  AddTaskControllerVC.swift
//  ToDoApp
//
//  Created by IOS DEV on 25/09/2019.
//  Copyright © 2019 IOS DEV. All rights reserved.
//

import UIKit

protocol AddTaskDelegate {
    func addTask(name: String, taskId: Int, taskChecked: Bool)
}

class AddTaskController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var addTaskTextField: UITextField!
    
    var delegate: AddTaskDelegate?
    var taskName = ""
    var taskId = 0
    var taskChecked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTaskTextField.text = taskName
        if taskId != 0 {
            titleLabel.text = "EDIT YOUR TASK"
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        if taskName != "" {
            delegate?.addTask(name: taskName, taskId: taskId, taskChecked: taskChecked)
            navigationController?.popViewController(animated: true)
        }
    }
}

extension AddTaskController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        taskName = textField.text ?? ""
    }
}
