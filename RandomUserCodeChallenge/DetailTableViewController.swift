//
//  DetailTableViewController.swift
//  RandomUserCodeChallenge
//
//  Created by Ryan Anderson on 3/5/21.
//

import UIKit

class DeatailTableViewController: UITableViewController {
    
    var users : [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        users = User.loadFromFile()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @IBAction func pickRandomUser(_ sender: Any) {
        guard let randomUser = users.randomElement()
        else {return}
        
        let alertController = UIAlertController(title: "\(randomUser.name)", message: "Congratulations! You were randomly picked as our winner!!", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Back", style: .cancel, handler: .none)
        
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
        
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
