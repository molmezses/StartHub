//
//  SettingsSurnameViewController.swift
//  StartHub
//
//  Created by Mustafa Ölmezses on 18.12.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SettingsSurnameViewController: UIViewController {
    
    @IBOutlet var EXNameText : UITextField!
    @IBOutlet var NEWNameText : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        let userUuid = String(Auth.auth().currentUser?.uid ?? "m")
        let postedBy = Firestore.firestore().collection("Users").document(userUuid)
        
        postedBy.getDocument { document, error in
            if let document = document, document.exists {
                let userData = document.data()
                let name = userData?["userSurname"] as? String ?? "olmadı"
                

                
                self.EXNameText.text = name
                
 
      
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

    @IBAction func saveButtonClicked(_ sender: Any) {
        let userUuid = String(Auth.auth().currentUser?.uid ?? "m")
        let postedBy = Firestore.firestore().collection("Users").document(userUuid)
        
        postedBy.getDocument { document, error in
            if let document = document, document.exists {
                let userData = document.data()
                let postedByUsername = userData?["userSurname"] as? String ?? "olmadı"
                
                let updatedUsername: [String: Any] = [
                            "userSurname": self.NEWNameText.text!
                        ]
                
                postedBy.updateData(updatedUsername)
                
                
                
                self.makeAlert(title: "SUCCES", message: "Surname Changed")
                
                self.EXNameText.text = self.NEWNameText.text
                self.NEWNameText.text = ""
                

      
            }else{
                self.makeAlert(title: "Eeeoe", message: "Eeeoe")
            }
        }
        
    }
    

}
