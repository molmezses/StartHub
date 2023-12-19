//
//  SettingsUsernameViewController.swift
//  StartHub
//
//  Created by Mustafa Ölmezses on 17.12.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SettingsUsernameViewController: UIViewController {
    
    @IBOutlet var EXuserNameText : UITextField!
    @IBOutlet var NEWuserNameText : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userUuid = String(Auth.auth().currentUser?.uid ?? "m")
        let postedBy = Firestore.firestore().collection("Users").document(userUuid)
        
        postedBy.getDocument { document, error in
            if let document = document, document.exists {
                let userData = document.data()
                let postedByUsername = userData?["username"] as? String ?? "olmadı"
                
                self.EXuserNameText.text = postedByUsername
                

      
            }else{
                self.makeAlert(title: "Eeeoe", message: "Eeeoe")
            }
        }
        
    }
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        let userUuid = String(Auth.auth().currentUser?.uid ?? "m")
        let postedBy = Firestore.firestore().collection("Users").document(userUuid)
        
        postedBy.getDocument { document, error in
            if let document = document, document.exists {
                let userData = document.data()
                let postedByUsername = userData?["username"] as? String ?? "olmadı"
                
                let updatedUsername: [String: Any] = [
                            "username": self.NEWuserNameText.text!
                        ]
                
                postedBy.updateData(updatedUsername)
                
                
                
                self.makeAlert(title: "SUCCES", message: "Username Changed")
                
                self.EXuserNameText.text = self.NEWuserNameText.text
                self.NEWuserNameText.text = "" 
                

      
            }else{
                self.makeAlert(title: "Eeeoe", message: "Eeeoe")
            }
        }
        
    }
        
        
        
        func makeAlert(title : String , message : String){
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            alert.addAction(okButton)
            self.present(alert, animated: true)
            
        }
        
        
    }
    
    
        
        
    
    

    


