//
//  ViewController.swift
//  SwiftLearning
//
//  Created by Bharath Shet on 06/03/20.
//  Copyright © 2020 Bharath Shet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var userDictionary:Dictionary<Int, Array<User>> = [:]
    var userList: Array<NewUser> = []
    
    @IBOutlet weak var userListTableView: UITableView!
    

    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        self.userListTableView.delegate = self
        self.userListTableView.dataSource = self
        self.userListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        //only one time will be called: kind of on-create
        
        apicall(){
                    response in
                    print("Got some callback")
                    self.userDictionary = response;
        //            self.userList = response
                    
                    self.userList.removeAll()
                    
                    for user in self.userDictionary{
                        self.userList.append(NewUser.init(myKey: user.key, userInfo: self.userDictionary[user.key]!))
                    }
                    
                    self.userList.sort { (lhs: NewUser, rhs: NewUser) -> Bool in
                        // you can have additional code here
                        return lhs.userId < rhs.userId
                    }
                    
                }
                self.userListTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("viewDidAppear")
        
    }
    
    func apicall(completionHandler:@escaping (_ response: Dictionary<Int, Array<User>>) -> ()) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data, error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                return
            }
            do {
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                //            print(jsonResponse)
                
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                var mUserDictionary:Dictionary<Int, Array<User>> = [:]

                for user in jsonArray{
                    guard let userId = user["userId"] as? Int else { return }
                    let item_dic = [User(user)]

                    if(mUserDictionary[userId] == nil){
                        mUserDictionary[userId] = item_dic.self
                    }else{
                        var previousItem = mUserDictionary[userId];
                        previousItem?.append(item_dic.first!)
                        mUserDictionary[userId] = previousItem
                    }
                }
                
                
//                var mUserList:Array<NewUser> = []
//
//                for user in jsonArray{
//                    guard let userId = user["userId"] as? Int else { return }
//                    var item_dic = [User(user)]
                    
                    
                    
                    //Not able to append second item to structure
//                    if(mUserList.count == 0){
//                        mUserList.append(NewUser.init(myKey: userId, userInfo: item_dic))
//                    }else{
//                        for user_list in mUserList{
//                            if(user_list.userId == userId){
////                                var previousItem = user_list.userTaskDetails
////                                previousItem.append(item_dic.first!)
////                                mUserList.append(NewUser.init(myKey: userId, userInfo: previousItem))
//                            }else{
////                                mUserList.append(NewUser.init(myKey: userId, userInfo: item_dic))
//                            }
//                        }
//                    }
                    
//                    for user_list in mUserList{
//
//                        if(user_list.userId == userId){
//                            var previousItem = user_list.userTaskDetails
//                            previousItem.append(item_dic.first!)
//                            mUserList.append(NewUser.init(myKey: userId, userInfo: previousItem))
//                        }else{
//                            mUserList.append(NewUser.init(myKey: userId, userInfo: item_dic))
//                        }
//                    }
//                }
               
                
                completionHandler(mUserDictionary)
//                completionHandler(mUserList)
                
                //Reload your table here
                DispatchQueue.main.async{
                    self.userListTableView.reloadData()
                }
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = self.userList[indexPath.row]
//        let device = userDictionary[indexPath.row]
        let toDoListVC = storyboard?.instantiateViewController(identifier: "ToDoListVC") as! ToDoListVC
        self.navigationController?.pushViewController(toDoListVC, animated: true)
        toDoListVC.user_tasks = device.userTaskDetails;
        toDoListVC.userId = device.userId;
        print("You choosen \(device.userId)")
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var user = self.userList[indexPath.row]
        
        
        
       // var user = userDictionary[indexPath.row]
        var title_id = user.userId
        cell.textLabel?.text = "\(title_id)"
        return cell
    }
}


struct User: Codable {
      var userId: Int
      var id: Int
      var title: String
      var completed: Bool
init(_ dictionary: [String: Any]) {
      self.userId = dictionary["userId"] as? Int ?? 0
      self.id = dictionary["id"] as? Int ?? 0
      self.title = dictionary["title"] as? String ?? ""
      self.completed = dictionary["completed"] as? Bool ?? false
    }
}

struct NewUser: Codable {
    var userId: Int
    var userTaskDetails: Array<User>
    
    init(myKey:Int,userInfo:Array<User>) {
        self.userId = myKey
        self.userTaskDetails = userInfo
    }
    
    mutating func updateTask(taskInfo: User){
        self.userTaskDetails.append(taskInfo)
    }
}



