//
//  ProfilViewController.swift
//  StartHub
//
//  Created by Mustafa Ölmezses on 29.11.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ProfilViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var userNameArray = [String]()
    var userSurnameArray = [String]()
    var usernameArray = [String]()
    var userCommentArray = [String]()
    var userImageArray = [String]()
    var userPPArray = [String]()
    var likeArray = [Int]()
    var documentIdArray = [String]()
    
    
    
    

    

    @IBOutlet var tableView : UITableView!
    @IBOutlet var userPP : UIImageView!
    @IBOutlet var userName : UILabel!
    @IBOutlet var userNameAndSurname : UILabel!
    @IBOutlet var postsCounterLabel : UILabel!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "ProfilInfo", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProfilInfo")
        
        let nibText = UINib(nibName: "TextHomeCell", bundle: nil)
        tableView.register(nibText, forCellReuseIdentifier: "TextHomeCell")
        
        userPP.layer.cornerRadius =  ((userPP.frame.size.width + userPP.frame.size.height) / 2) / 2
        userPP.clipsToBounds = true
  
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getUserInfo()
        getDataFromFirestore()
       
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPPArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if userImageArray[indexPath.row] == "none"{
            let cellText = tableView.dequeueReusableCell(withIdentifier: "TextHomeCell", for: indexPath) as! TextHomeCell
            cellText.userName.text = usernameArray[indexPath.row]
            cellText.userNameAndSurname.text = userNameArray[indexPath.row] + " " + userSurnameArray[indexPath.row]
            cellText.date.text = "21.09.2002"
            cellText.userPP.sd_setImage(with: URL(string: self.userPPArray[indexPath.row]))
            cellText.userPostText.text = userCommentArray[indexPath.row]
            cellText.selectionStyle = .none
            cellText.likeButtonOulet.isHidden = true
            cellText.likesLabel.isHidden = true
            cellText.commentsButtonOulet.isHidden = true
            cellText.commentsLabel.isHidden = true

            
            
            
            
            return cellText
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilInfo", for: indexPath) as! ProfilInfo
        cell.userName.text = usernameArray[indexPath.row]
        cell.userNameAndSurname.text = userNameArray[indexPath.row] + " " + userSurnameArray[indexPath.row]
        cell.date.text = "21.09.2002"
        cell.userImage.sd_setImage(with:URL(string: self.userImageArray[indexPath.row]))
        cell.userPP.sd_setImage(with: URL(string: self.userPPArray[indexPath.row]))
        cell.userPostText.text = userCommentArray[indexPath.row]
        cell.selectionStyle = .none

        
        
        return cell
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
            }else{
                print("mustafafaffafa")
            }
        }
    }
    
    func getDataFromFirestore() {
        
        let fireStoreDatabase = Firestore.firestore()
        
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Firestore error: \(error.localizedDescription)")
            } else {
                if let snapshot = snapshot, !snapshot.isEmpty {
                    // Verilerin tekrarlanmaması için array'leri temizle
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    self.usernameArray.removeAll(keepingCapacity: false)
                    self.userNameArray.removeAll(keepingCapacity: false)
                    self.userSurnameArray.removeAll(keepingCapacity: false)
                    self.userPPArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot.documents {
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        
                        
                        let isCurrentUser = String((Auth.auth().currentUser?.email)!)
                        
                        if isCurrentUser == document.get("PostedBy") as? String{
                            
                            if let postComment = document.get("postComment") as? String {
                                self.userCommentArray.append(postComment)
                            }
                            if let userPP = document.get("postedByUserPP") as? String {
                                self.userPPArray.append(userPP)
                            }
                            if let imageURL = document.get("imageUrl") as? String {
                                self.userImageArray.append(imageURL)
                            }
                            if let userName = document.get("PostedByName") as? String {
                                self.userNameArray.append(userName)
                            }
                            if let username = document.get("PostedByUserName") as? String {
                                self.usernameArray.append(username)
                            }
                            if let userSurname = document.get("PostedBySurname") as? String {
                                self.userSurnameArray.append(userSurname)
                            }
                            
                        }

                    }
                    
                    self.tableView.reloadData()
                } else {
                    print("Snapshot is empty or nil.")
                }
            }
        }

    }

}
