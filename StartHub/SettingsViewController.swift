//
//  SettingsViewController.swift
//  StartHub
//
//  Created by Mustafa Ölmezses on 30.11.2023.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    @IBOutlet var tableView: UITableView!
    
    let cellSettings : [String] = ["Username" ,"Name","Surname","Password","Profil Photo"]

    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        let nib = UINib(nibName: "SettingsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SettingsCell")
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 20
        tableView.isScrollEnabled = false

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        
            Cell.CellText.text = cellSettings[indexPath.row]
            Cell.contentView.layer.cornerRadius = 100
            Cell.contentView.layer.masksToBounds = true
            Cell.contentView.layer.cornerRadius = 10
            Cell.contentView.layer.masksToBounds = true
            Cell.contentView.clipsToBounds = true
            Cell.selectionStyle = .none
            
            return Cell
   
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "SettingsUsernameViewController", sender: nil)
        case 1:
            self.performSegue(withIdentifier: "SettingsUserNameAndSurnameViewController", sender: nil)
        case 2:
            self.performSegue(withIdentifier: "changeSurnameViewController", sender: nil)
        case 3:
            self.performSegue(withIdentifier: "toSettingsPassword", sender: nil)
        case 4:
            self.performSegue(withIdentifier: "PhotoSettings", sender: nil)
        default:
            break
        }
    }
    
    
    
   
   
    @IBAction func logOutButtonClicked(_ sender: Any) {
            do{
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "toViewController", sender: nil)
            }catch{
                print("ERROR LOGOUT")
            }
            
        }
    }
    

    

