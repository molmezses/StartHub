//
//  HomeViewController.swift
//  StartHub
//
//  Created by Mustafa Ölmezses on 2.12.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import SDWebImage



class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    @IBOutlet var tableView : UITableView!
    
    
    var userNameArray = [String]()
    var userSurnameArray = [String]()
    var usernameArray = [String]()
    var userCommentArray = [String]()
    var userImageArray = [String]()
    var userPPArray = [String]()
    var likeArray = [Int]()
    var dateArray = [Timestamp]()

    var documentIdArray = [String]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "HomeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HomeCell")
        
        let nibText = UINib(nibName: "TextHomeCell", bundle: nil)
        tableView.register(nibText, forCellReuseIdentifier: "TextHomeCell")
        
        
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromFirestore()
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernameArray.count
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
            cellText.likesLabel.text = String(likeArray[indexPath.row])
            cellText.documrntIdLabel.text = documentIdArray[indexPath.row]

            
            let timestampFromFirestore: Timestamp = dateArray[indexPath.row]
            let date: Date = timestampFromFirestore.dateValue()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let formattedDate = dateFormatter.string(from: date)
            cellText.date.text = formattedDate
            
            
            
            return cellText
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.userName.text = usernameArray[indexPath.row]
        cell.userNameAndSurname.text = userNameArray[indexPath.row] + " " + userSurnameArray[indexPath.row]
        cell.date.text = "21.09.2002"
        cell.userImage.sd_setImage(with:URL(string: self.userImageArray[indexPath.row]))
        cell.userPP.sd_setImage(with: URL(string: self.userPPArray[indexPath.row]))
        cell.userPostText.text = userCommentArray[indexPath.row]
        cell.selectionStyle = .none
        cell.likesLabel.text = String(likeArray[indexPath.row])
        cell.documrntIdLabel.text = documentIdArray[indexPath.row]
        
        let timestampFromFirestore: Timestamp = dateArray[indexPath.row]
        let date: Date = timestampFromFirestore.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: date)
        cell.date.text = formattedDate
    
        

      

        
        
        return cell
    }
    
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDocumentId = documentIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toCommentsVC", sender: selectedDocumentId)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCommentsVC" {
            if let destinationVC = segue.destination as? CommentsViewController {
                // "sender" olarak aldığımız değeri hedef view controller'a iletiyoruz
                destinationVC.segueDocumentId = sender as! String
            }
        }
    }
    
    // ...

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
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        if let date = document.get("date") as? Timestamp{
                            self.dateArray.append(date)
                        }

                        
                    }

                    self.tableView.reloadData()
                } else {
                    print("Snapshot is empty or nil.")
                }
            }
        }
    }
    
    
    

    // ...

    
 
  
    

}
