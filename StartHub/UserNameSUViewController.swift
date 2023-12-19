//
//  UserNameSUViewController.swift
//  StartHub
//
//  Created by Mustafa Ölmezses on 27.11.2023.
//

import UIKit
import Firebase
import FirebaseFirestore



class UserNameSUViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userNameText: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameText.delegate = self
        textView.isEditable = false
        
        
        
    }
    

    @IBAction func nextButtonClicked(_ sender: Any) {
        
        if userNameText.text != ""{
            
            //Firebase Firestore kullanıcı iblgilerimi yükleme işlemi
            
            let db = Firestore.firestore()
            
            let userData : [String : Any] = [
            
                "username" : userNameText.text!
            
            ]
            
            let userId = Auth.auth().currentUser?.uid
            db.collection("Users").document(userId!).setData(userData)
            
            self.performSegue(withIdentifier: "toUserInfoSUViewController", sender: nil)
            
        }else{
            self.makeAlert(title: "Error", message: "f")
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
            
            self.view.frame.origin.y = -140
            
        }
    }
    
    
    func makeAlert(title : String , message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    

}
