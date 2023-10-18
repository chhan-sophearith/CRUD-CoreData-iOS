//
//  ViewController.swift
//  CoreDataDemo-iOS
//
//  Created by Chhan Sophearith on 9/10/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createUserBtn: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var users = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"
        createUserBtn.addTarget(self, action: #selector(tapAddUser), for: .touchUpInside)
        self.getUser()
    }
    
    func getUser() {
        do {
            users = try context.fetch(Person.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch let err {
            print("err ->:", err)
        }
    }
    
    @objc func tapAddUser() {
        let alert = UIAlertController(title: "Create User", message: "Please Create New User", preferredStyle: .alert)
        alert.addTextField()
        alert.textFields?.first?.placeholder = "Name"
        alert.addTextField()
        alert.textFields?.last?.placeholder = "Age"
        alert.textFields?.last?.keyboardType = .decimalPad
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            if let name = alert.textFields?.first?.text,
               let age = Int(alert.textFields?.last?.text ?? "") {
                self.createUser(name: name, age: age)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func tapEdit(user: Person) {
        let alert = UIAlertController(title: "Edit User", message: "Please Edit User", preferredStyle: .alert)
        alert.addTextField()
        alert.textFields?.first?.placeholder = "Name"
        alert.addTextField()
        alert.textFields?.last?.placeholder = "Age"
        alert.textFields?.last?.keyboardType = .decimalPad
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { _ in
            if let name = alert.textFields?.first?.text,
               let age = Int(alert.textFields?.last?.text ?? "") {
                self.updateUser(user: user, name: name, age: age)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    

    @objc func createUser(name: String, age: Int) {
        let user = Person(context: context)
        user.name = name
        user.age = Int16(age)
        user.createAt = Date()
        do {
            try context.save()
            self.getUser()
        } catch let err {
            print("err ->:", err)
        }
    }
    
    func updateUser(user: Person, name: String, age: Int) {
        user.name = name
        user.age = Int16(age)
        do {
            try context.save()
            self.getUser()
        } catch let err {
            print("err ->:", err)
        }
    }
    
    func deteleUser(user: Person) {
        let alert = UIAlertController(title: "Choose", message: "Are you sure you want delete?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.context.delete(user)
            do {
                try self.context.save()
                self.getUser()
            } catch let err {
                print("err ->:", err)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func actionSheet(user: Person) {
        let actionSheet = UIAlertController(title: "Choose", message: "Please select option", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deteleUser(user: user)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            self.tapEdit(user: user)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(actionSheet, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell {
            let user = users[indexPath.row]
            cell.setupValue(user: user)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        self.actionSheet(user: user)
    }
}
