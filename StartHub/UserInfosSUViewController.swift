//
//  UserInfosSUViewController.swift
//  StartHub
//
//  Created by Mustafa Ölmezses on 27.11.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore



class UserInfosSUViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var surNameText: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameText.delegate = self
        surNameText.delegate = self
        textView.isEditable = false
        
    }
    

   
    @IBAction func nextButtonClicked(_ sender: Any) {
        
        
        if nameText.text != "" && surNameText.text != ""{
            
            let db = Firestore.firestore()
            
            let userId = Auth.auth().currentUser?.uid
            
            let userData : [String : Any] = [
            
                "userName" : nameText.text! ,
                "userSurname" : surNameText.text!
            
            ]
            
            db.collection("Users").document(userId!).updateData(userData)
            
            
            self.performSegue(withIdentifier: "toProfilPhotosSUViewController", sender: nil)
            
        }else{
            makeAlert(title: "ERROR", message: "ERROR F")
        }
        
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.6) {
            
            self.view.frame.origin.y = 0
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.6) {
            
            self.view.frame.origin.y = -146
            
        }
    }
    
    
    func makeAlert(title : String , message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }

}
