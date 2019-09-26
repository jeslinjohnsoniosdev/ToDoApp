//
//  TasksTVC.swift
//  ToDoApp
//
//  Created by IOS DEV on 25/09/2019.
//  Copyright © 2019 IOS DEV. All rights reserved.
//

import UIKit

protocol CheckBoxDelegate {
    func checkBox(state: Bool, index: Int?)
    func deleteTask(index: Int?)
}

class TasksTVC: UITableViewCell {

    @IBOutlet weak var checkBoxOutlet: UIButton!
    @IBOutlet weak var taskNameLabel: UILabel!
    
    var indexPathRow: Int?
    var delegate: CheckBoxDelegate?
    var tasks: [Tasks]?
    
    @IBAction func checkBoxAction(_ sender: Any) {
        if tasks![indexPathRow!].checked {
            delegate?.checkBox(state: false, index: indexPathRow)
        } else {
            delegate?.checkBox(state: true, index: indexPathRow)
        }
    }
    
    @IBAction func deleteTaskAction(_ sender: Any) {
        self.delegate?.deleteTask(index: indexPathRow)
    }
    
    
}
