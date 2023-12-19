//
//  TextHomeCell.swift
//  StartHub
//
//  Created by Mustafa Ölmezses on 5.12.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class TextHomeCell: UITableViewCell {
    
    
    
    
    @IBOutlet var userPP : UIImageView!
    @IBOutlet var userNameAndSurname : UILabel!
    @IBOutlet var userName : UILabel!
    @IBOutlet var date : UILabel!
    @IBOutlet weak var userPostText: UILabel!
    @IBOutlet var likeButtonOulet: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet var commentsButtonOulet: UIButton!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet var ticketsButtonOulet: UIButton!
    @IBOutlet weak var ticketsLabel: UILabel!
    @IBOutlet weak var documrntIdLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        userPP.layer.cornerRadius =  ((userPP.frame.size.width + userPP.frame.size.height) / 2) / 2
        userPP.clipsToBounds = true
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeButton(_ sender: Any) {
        let fireStoreDatabase = Firestore.firestore()

            // Kontrol etmeden önce likesLabel.text'in nil olup olmadığını kontrol et
            if var likeCount = Int(likesLabel.text ?? "0") {
                var systemImage: UIImage?

                if likeButtonOulet.isSelected {
                    systemImage = UIImage(systemName: "heart")?.withTintColor(.black, renderingMode: .alwaysOriginal)
                    likeCount -= 1
                } else {
                    systemImage = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
                    likeCount += 1
                }

                likeButtonOulet.isSelected.toggle()
                likeButtonOulet.setImage(systemImage, for: .normal)

                // Güvenli bir şekilde Firestore'a veri gönder
                if let documentId = documrntIdLabel.text {
                    let likeStore = ["likes": likeCount]
                    fireStoreDatabase.collection("Posts").document(documentId).setData(likeStore, merge: true) { error in
                        if let error = error {
                            print("Firestore veri güncelleme hatası: \(error.localizedDescription)")
                        }
                    }
                }

                likesLabel.text = "\(likeCount)"
            }
    }
    
    
}
