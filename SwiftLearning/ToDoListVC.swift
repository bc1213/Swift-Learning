//
//  ToDoListVC.swift
//  SwiftLearning
//
//  Created by Bharath Shet on 06/03/20.
//  Copyright © 2020 Bharath Shet. All rights reserved.
//

import UIKit

class ToDoListVC: UIViewController {
    
    var user_tasks:Array<User>!
    var userId:Int = 0
    
    @IBOutlet weak var userTodoItemTableView: UITableView!
    @IBOutlet weak var userIdLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        //initializing the table view
        self.userTodoItemTableView.delegate = self
        self.userTodoItemTableView.dataSource = self
        self.userTodoItemTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.userIdLabel.text = "TODO items of User: \(userId)"
        self.userIdLabel.textAlignment = .center
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        self.userTodoItemTableView.reloadData()
    }
    
    func showAlert(userTodo: User) {
        let alert = UIAlertController(title: "Details", message: "Title: \(userTodo.title) \n Status: \(userTodo.completed == true ? "Completed" : "Pending") ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok!", style: .default, handler: { [unowned self] action in
            
            }))
        self.present(alert, animated: true, completion: nil)
    }

}


extension ToDoListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = user_tasks[indexPath.row]
        print("You choosen \(device.title)")
        showAlert(userTodo: device)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .delete {
               
            }
        }
    
}

extension ToDoListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user_tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var device = user_tasks[indexPath.row]
        var title_id = device.title
        cell.textLabel?.text = "\(title_id)"
        
        if(device.completed == true){
            cell.textLabel?.textColor = .blue
        }else{
            cell.textLabel?.textColor = .red
        }
        return cell
    }
}


