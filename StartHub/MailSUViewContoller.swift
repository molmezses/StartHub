//
//  MailSUViewContoller.swift
//  StartHub
//
//  Created by Mustafa Ölmezses on 26.11.2023.
//

import UIKit
import Firebase
import FirebaseAuth



class MailSUViewContoller: UIViewController {

    @IBOutlet weak var eMailText: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.isEditable = false
        
        
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    
    @IBAction func nextButtonClicked(_ sender: Any) {
        
        
        if eMailText.text != ""{
            
            Auth.auth().createUser(withEmail: eMailText.text!, password: "123456789") { auth, error in
                
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                }else{
                    Auth.auth().signIn(withEmail: self.eMailText.text!, password: "123456789") { auth, error in
                        
                        if error != nil{
                            self.makeAlert(title: "Error", message: "Error")
                        }else{
                            self.performSegue(withIdentifier: "toPasswordSUViewController", sender: nil)
                        }
                        
                    }
                    
                }
                
            }
            
        }else{
            self.makeAlert(title: "Error", message: "Email alanı  bos gecilemez ")
        }
        
    }
    
    func makeAlert(title:String , message : String){
                
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    
}
