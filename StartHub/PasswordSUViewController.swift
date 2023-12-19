//
//  PasswordSUViewController.swift
//  StartHub
//
//  Created by Mustafa Ölmezses on 26.11.2023.
//

import UIKit
import Firebase
import FirebaseAuth

class PasswordSUViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordAgainText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.isEditable  = false
        passwordText.delegate = self
        passwordAgainText.delegate = self

        
        
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        
        
        if passwordText.text != "" && passwordAgainText.text != ""{
            
            if passwordText.text == passwordAgainText.text {
                
                //FirebaseAuth şifre güncelleme işlemleri
                
                if let user  = Auth.auth().currentUser{
                    user.updatePassword(to: passwordText.text!)
                    performSegue(withIdentifier: "toUserNameSUViewController", sender: nil)
                }else{
                    self.makeAlert(title: "EROR", message: "F")
                }
                
            }else{
                self.makeAlert(title: "ERROR", message: "Şİfreler birbirleri ile uyuşmuyor")
            }
            
            
        }else{
            self.makeAlert(title: "ERROR", message: "Şifre kısımları boş geçilemez")
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
            
            self.view.frame.origin.y = -156
            
        }
    }
    
    
    func makeAlert(title : String , message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    
    

}
