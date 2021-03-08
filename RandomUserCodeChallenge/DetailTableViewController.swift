//
//  DetailTableViewController.swift
//  RandomUserCodeChallenge
//
//  Created by Ryan Anderson on 3/5/21.
//

import UIKit

class DeatailTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    var users : [User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        users = User.loadFromFile()
        
        amountOfUsers.dataSource = self
        amountOfUsers.delegate = self
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 2
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if component == 0 {
                return 1
            }  else {
                return users.count
            }
        }
    
   
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if component == 0 {
                return "How Many Users?"
            } else {
            
            return String(row + 1)
            }
        }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 {
            pickerView.reloadAllComponents()
        }
    }
    
    
        @IBOutlet weak var amountOfUsers: UIPickerView!
        

    @IBAction func pickRandomUser(_ sender: UIButton) {
        
        var randerusers : [User] = users

        let num = amountOfUsers.selectedRow(inComponent: 1)
        
        var selectedUsers : [String] = []
        if users.count == 0 {
            let alertController = UIAlertController(title: "Add Users", message: nil, preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Back", style: .cancel, handler: .none)
            
            alertController.addAction(cancelButton)
            present(alertController, animated: true, completion: nil)
            
        }else if users.count == 1 {
            let alertController = UIAlertController(title: "\(selectedUsers)", message: "There is only one User to choose from. Consider adding more users", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Back", style: .cancel, handler: .none)
            
            alertController.addAction(cancelButton)
            present(alertController, animated: true, completion: nil)
        } else {
        
        
        for _ in 0...num {
            let randomUser = randerusers.randomElement()
            if let user = randomUser?.name {
                selectedUsers.append(user)
                randerusers.removeAll {$0.name.hasPrefix(user)}
//                print(randerusers)
            }

        }
//        print(selectedUsers)
        
            let alertController = UIAlertController(title: "\(selectedUsers)", message: "Congratulations! You were randomly picked as our winner!!", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Back", style: .cancel, handler: .none)
        
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
        }
    }
    
    func getUser(at indexPath: IndexPath) -> User {
        
        let sortedUsers = users.sorted(by: { $0.name < $1.name
        })
        
        User.saveToFile(users: sortedUsers)
        
       return sortedUsers[indexPath.row]
    }

    // MARK: - Table view data source


        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else {fatalError("No Cell 😬")}
            
        
        let user = getUser(at: indexPath)
        
        cell.configure(user: user)
        
        
        return cell
    }
    
    
    @IBAction func addUser(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Enter User Name", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Name"
            textField.textAlignment = .center
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: .none)

        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (alert) in
            guard let textFieldArray = alertController.textFields,             let nameText = textFieldArray[0].text
            else {return}
            let user = User(name: nameText.uppercased())
            self.users.append(user)
            User.saveToFile(users: self.users)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
       
        alertController.addAction(cancelButton)
        alertController.addAction(submitAction)
       
        present(alertController, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            users.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        User.saveToFile(users: users)
    }
    
}
