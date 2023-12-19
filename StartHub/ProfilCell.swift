//
//  ProfilCell.swift
//  StartHub
//
//  Created by Mustafa Ölmezses on 12.12.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ProfilCell: UITableViewCell {
    
    
    @IBOutlet var userPP: UIImageView!
    @IBOutlet var userNameAndSurname: UILabel!
    @IBOutlet var userName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        userPP.layer.cornerRadius =  ((userPP.frame.size.width + userPP.frame.size.height) / 2) / 2
        userPP.clipsToBounds = true
        
        getUserInfo()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    func getUserInfo() {
        // Kullanıcının bilgilerini çekme
        let userUuid = String(Auth.auth().currentUser?.uid ?? "m")
        let postedBy = Firestore.firestore().collection("Users").document(userUuid)
        
        postedBy.getDocument { document, error in
            if let document = document, document.exists {
                let userData = document.data()
                let postedByName = userData?["userName"] as? String ?? ""
                let postedBySurname = userData?["userSurname"] as? String ?? ""
                let postedByUsername = userData?["username"] as? String ?? ""
                let postedByUserPP = userData?["userProfilPhoto"] as? String ?? ""


                
                
                let fullName = postedByName + " " + postedBySurname
                self.userNameAndSurname.text = fullName
                self.userName.text = postedByUsername
                self.userPP.sd_setImage(with: URL(string: postedByUserPP))
                
                
                if let userName = userData?["userName"] as? String,
                   let userSurname = userData?["userSurname"] as? String {
                    self.userNameAndSurname.text = userName + " " + userSurname
                }
            }
        }
    }

    
}
