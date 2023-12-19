//
//  SettingsPasswordViewController.swift
//  StartHub
//
//  Created by Mustafa Ölmezses on 19.12.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SettingsPasswordViewController: UIViewController {
    
    @IBOutlet var eMail : UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        
        
        
        
        if eMail.text != "" {
            Auth.auth().sendPasswordReset(withEmail: eMail.text!) { error in
                    if let error = error {
                        print("Şifre sıfırlama e-postası gönderilirken hata oluştu: \(error.localizedDescription)")
                        self.makeAlert(title: "Şifre sıfırlama e-postası gönderilirken hata oluştu", message: String(error.localizedDescription))

                    } else {
                        print("Şifre sıfırlama e-postası başarıyla gönderildi.")
                        self.makeAlert(title: "Succes", message: "Şifre sıfırlama bağlantısı \(self.eMail.text!) tanımlı mail adrerine gönderildi")
                    }
                }
            
        }else{
            self.makeAlert(title: "Error", message: "Lütfen geçerli bir mail adresi giriniz")
        }
        
        
    }
    
    func makeAlert(title : String , message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    
}
