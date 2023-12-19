//
//  HomeCell.swift
//  StartHub
//
//  Created by Mustafa Ölmezses on 2.12.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class HomeCell: UITableViewCell {
    
    
    @IBOutlet var userPP : UIImageView!
    @IBOutlet var userNameAndSurname : UILabel!
    @IBOutlet var userName : UILabel!
    @IBOutlet var date : UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userPostText: UILabel!
    @IBOutlet weak var documrntIdLabel: UILabel!
    @IBOutlet var likeButtonOulet: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userPP.layer.cornerRadius =  ((userPP.frame.size.width + userPP.frame.size.height) / 2) / 2
        userPP.clipsToBounds = true
        userImage.layer.cornerRadius = userImage.frame.size.width / 20
        userName.clipsToBounds = true
        userImage.contentMode = .scaleAspectFill
        
        
        

        
        
    }
    
    private func findViewController() -> UIViewController? {
            var responder: UIResponder? = self
            while let currentResponder = responder {
                if let viewController = currentResponder as? UIViewController {
                    return viewController
                }
                responder = currentResponder.next
            }
            return nil
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    
    @IBAction func likeButton(_ sender: Any) {
        let fireStoreDatabase = Firestore.firestore()

        if var likeCount = Int(likesLabel.text!) {
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
            let likeStore = ["likes": likeCount]
            fireStoreDatabase.collection("Posts").document(documrntIdLabel.text!).setData(likeStore, merge: true)
            likesLabel.text = "\(likeCount)"
        }
    }
    
    
    
    @IBAction func Comment(_ sender: Any) {
        
        if let viewController = findViewController() {
                    viewController.performSegue(withIdentifier: "toCommentsVC", sender: self)
                }
        
    }
    
    
    
    
    
    
}
