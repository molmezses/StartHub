//
//  SignInViewController.swift
//  StartHub
//
//  Created by Mustafa Ölmezses on 26.11.2023.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {
    
    
    @IBOutlet weak var eMailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    
    @IBAction func forgotButtonClicked(_ sender: Any) {
        
    }
    
    
    @IBAction func googleButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: eMailText.text!, password: passwordText.text!) { authdata, error in
            
            if error != nil{
                self.makeAlert(title: "Error", message: "Error")
            }else{
                self.performSegue(withIdentifier: "toTabBar", sender: nil)
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
