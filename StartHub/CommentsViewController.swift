//
//  CommentsViewController.swift
//  StartHub
//
//  Created by Mustafa Ölmezses on 14.12.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore







class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    

    
    @IBOutlet var tableView : UITableView!
    @IBOutlet var userPP : UIImageView!
    @IBOutlet var userName : UILabel!
    @IBOutlet var userNameAndSurname : UILabel!
    @IBOutlet var userCommentText :UITextView!
    

    
    var documentIdArray = [String]()
    var segueDocumentId :String = ""
    var userNameArray = [String]()
    var userNameAndSurnameArray = [String]()
    var userCommentArray = [String]()
    var userPPArray = [String]()
    var dateArray = [Timestamp]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userCommentText.isEditable = true
        userCommentText.delegate = self
        userCommentText.textColor = UIColor.gray
        userCommentText.layer.cornerRadius = 20
       

        getDataFromFirestore()
        getPostsFromFirestore()
        getUserInfo()

        print(segueDocumentId)
        
        userPP.layer.cornerRadius =  ((userPP.frame.size.width + userPP.frame.size.height) / 2) / 2
        userPP.clipsToBounds = true
        
        let nibComment = UINib(nibName: "TextHomeCell", bundle: nil)
        tableView.register(nibComment, forCellReuseIdentifier: "TextHomeCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let userUuid = String(Auth.auth().currentUser?.uid ?? "m")
        let postedBy = Firestore.firestore().collection("Users").document(userUuid)
        
        postedBy.getDocument { document, error in
            if let document = document , document.exists{
                
                let userData = document.data()
                
                 let PostedByName =  userData?["userName"] as? String ?? ""
                 let PostedBySurname =  userData?["userSurname"] as? String ?? ""
                 let PostedByUsername =  userData?["username"] as? String ?? ""
                 let PostedByUserPP = userData?["userProfilPhoto"] as? String ?? ""
                 let fullName = PostedByName + " " + PostedBySurname
                
                
                self.userName.text = PostedByUsername
                self.userNameAndSurname.text = fullName
                self.userPP.sd_setImage(with: URL(string: PostedByUserPP))
                
     
            }
        }
        

        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.gray{
            textView.text = ""
            textView.textColor = UIColor.darkGray
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == ""{
            textView.text = "Enter a comment!"
            textView.textColor = UIColor.gray
        }
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userCommentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "TextHomeCell", for: indexPath) as! TextHomeCell
        
        Cell.userName.text = userNameArray[indexPath.row]
        Cell.userPostText.text = userCommentArray[indexPath.row]
        Cell.userNameAndSurname.text = userNameAndSurnameArray[indexPath.row]
        Cell.userPP.sd_setImage(with: URL(string: self.userPPArray[indexPath.row]))
        
        let timestampFromFirestore: Timestamp = dateArray[indexPath.row]
        let date: Date = timestampFromFirestore.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: date)
        Cell.date.text = formattedDate
        
        Cell.selectionStyle = .none
        Cell.likeButtonOulet.isHidden = true
        Cell.likesLabel.isHidden = true
        Cell.commentsButtonOulet.isHidden = true
        Cell.commentsLabel.isHidden = true

        
        
        
        return Cell
    }
 
    
    func getDataFromFirestore() {
        let fireStoreDatabase = Firestore.firestore()
        let documentId = String(segueDocumentId)
        
        fireStoreDatabase.collection("Comments").document(documentId).collection("userComments").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Firestore hatası: \(error.localizedDescription)")
            } else {
                guard let snapshot = snapshot else {
                    print("Snapshot boş veya nil.")
                    return
                }

                self.userCommentArray.removeAll()
                self.userPPArray.removeAll()
                self.userNameArray.removeAll()

                for document in snapshot.documents {
                    if let userCommentDB = document.get("userComment") as? String {
                        self.userCommentArray.append(userCommentDB)
                    }
                    if let userPPDB = document.get("userPP") as? String {
                        self.userPPArray.append(userPPDB)
                    }
                    if let userNameDB = document.get("userName") as? String {
                        self.userNameArray.append(userNameDB)
                    }
                    if let userNameAndSurnameDB = document.get("userNameAndSurname") as? String {
                        self.userNameAndSurnameArray.append(userNameAndSurnameDB)
                    }
                    if let date = document.get("date") as? Timestamp{
                        self.dateArray.append(date)
                    }
                }

                // Verileri aldıktan sonra tableView'ı güncelle
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    // Diziyi tekrar kontrol et
                    print(self.userCommentArray)
                }
            }
        }
    }


    
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        
        let firestoreDatabase = Firestore.firestore()
        
   
        let commentsCollection = firestoreDatabase.collection("Comments")
        let newDocumentRef = commentsCollection.document(segueDocumentId)
        
        let data: [String: Any] = [
            "exampleField": "exampleValue",
        ]
        newDocumentRef.setData(data)
        
        
        let childDocumentRef = newDocumentRef.collection("userComments").document()
        
        let userUuid = String(Auth.auth().currentUser?.uid ?? "m")
        let postedBy = Firestore.firestore().collection("Users").document(userUuid)
        
        postedBy.getDocument { document, error in
            if let document = document , document.exists{
                
                let userData = document.data()
                
                 let PostedByName =  userData?["userName"] as? String ?? ""
                 let PostedBySurname =  userData?["userSurname"] as? String ?? ""
                 let PostedByUsername =  userData?["username"] as? String ?? ""
                 let PostedByUserPP = userData?["userProfilPhoto"] as? String ?? ""
                
                let fullName = PostedByName + " " + PostedBySurname

                let childData: [String: Any] = [
                    "userName": PostedByUsername,
                    "userNameAndSurname": fullName,
                    "userPP" : PostedByUserPP,
                    "userComment" : String(self.userCommentText.text),
                    "date": FieldValue.serverTimestamp()
                    
                ]
                
                childDocumentRef.setData(childData) { error in
                    if let error = error {
                        print("Alt belge oluşturulurken hata oluştu: \(error.localizedDescription)")
                    } else {
                        print("Alt belge başarıyla oluşturuldu")
                        
                    }
                }
            }
            
            
            self.userCommentText.text = "Enter a comment!"
            self.tabBarController?.selectedIndex = 0
            self.userCommentText.resignFirstResponder()
            
        }
        
        
        
        
        
        
    }
    
    
    
    func getPostsFromFirestore() {
        let fireStoreDatabase = Firestore.firestore()

        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Firestore error: \(error.localizedDescription)")
            } else {
                if let snapshot = snapshot, !snapshot.isEmpty {
                    
                    self.documentIdArray.removeAll(keepingCapacity: false)

                    for document in snapshot.documents {
                        
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
            
                    }

                    self.tableView.reloadData()
                } else {
                    print("Snapshot is empty or nil.")
                }
            }
        }
    }
    
    
    func getUserInfo(){
        let userUuid = String(Auth.auth().currentUser?.uid ?? "m")
        let postedBy = Firestore.firestore().collection("Users").document(userUuid)
        
        postedBy.getDocument { document, error in
            if let document = document , document.exists{
                
                let userData = document.data()
                
                 let PostedByName =  userData?["userName"]
                 let PostedBySurname =  userData?["userSurname"]
                 let PostedByUsername =  userData?["username"]
                 let PostedByUserPP = userData?["userProfilPhoto"]
     
            }
        }
    }
    
  

}
