//
//  UploadViewController.swift
//  StartHub
//
//  Created by Mustafa Ölmezses on 1.12.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class UploadViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    
    @IBOutlet var textView : UITextView!
    @IBOutlet var userPP : UIImageView!
    @IBOutlet var postImage : UIImageView!
    @IBOutlet var userNameAndSurname : UILabel!
    @IBOutlet var username : UILabel!
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userPP.layer.cornerRadius =  ((userPP.frame.size.width + userPP.frame.size.height) / 2) / 2
        userPP.clipsToBounds = true
        textView.isEditable = true
        textView.delegate = self
        textView.textColor = UIColor.gray
        
        postImage.contentMode = .scaleAspectFit
        getUserInfo()
        
        
        
        
    }
    
    @IBAction func addPhotoClicked(_ sender: Any) {
        chooseImage()
        
    }
    @objc func chooseImage(){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        postImage.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.gray{
            textView.text = ""
            textView.textColor = UIColor.darkGray
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == ""{
            textView.text = "What's going on?"
            textView.textColor = UIColor.gray
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
       
    @IBAction func sendButtonClicked(_ sender: Any) {
        
        
        if imageView.image == nil{
            let firestoreDatabase = Firestore.firestore()
            var firestoreReference: DocumentReference? = nil
            
            // Post sahibinin bilgilerini çekme
            let userUuid = String(Auth.auth().currentUser?.uid ?? "m")
            let postedBy = Firestore.firestore().collection("Users").document(userUuid)
            
            postedBy.getDocument { document, error in
                if let document = document, document.exists {
                    let userData = document.data()
                    let PostedByName =  userData?["userName"]
                    let PostedBySurname =  userData?["userSurname"]
                    let PostedByUsername =  userData?["username"]
                    let PostedByUserPP = userData?["userProfilPhoto"]
                    
                    let firestorePost = [
                        "PostedBy": Auth.auth().currentUser!.email!,
                        "PostedByName": PostedByName,
                        "imageUrl": "none",
                        "PostedBySurname": PostedBySurname,
                        "PostedByUserName": PostedByUsername,
                        "postComment": self.textView.text!,
                        "postedByUserPP": PostedByUserPP,
                        "date": FieldValue.serverTimestamp(),
                        "likes": 0
                    ] as [String: Any]
                    
                    firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                        if error != nil {
                            self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                        } else {
                            self.imageView.image = UIImage(named: "select.png")
                            self.textView.text = ""
                            self.tabBarController?.selectedIndex = 0
                        }
                    })
                }
            }
        }else{
            let storage = Storage.storage()
            let storageReference = storage.reference()
                    
                    let mediaFolder = storageReference.child("PostPhotos") // PostPhotos klasörüne git
                    
                    if let data = imageView.image?.jpegData(compressionQuality: 0.5){
                        
                        let uuid = UUID().uuidString
                        
                        let imageReference = mediaFolder.child("\(uuid).jpg")
                        imageReference.putData(data , metadata: nil) { metadata, error in
                            
                            if error != nil{
                                self.makeAlert(title: "Error", message: error?.localizedDescription ??  "Error")
                            }else{
                                
                                imageReference.downloadURL { url, error in
                                    
                                    if error == nil{
                                        
                                        let imageUrl =  url?.absoluteString
                                        
                                        
                                        //DATABASE
                                        
                                     
                                        let firestoreDatabase = Firestore.firestore()
                                        
                                        var firestoreReference : DocumentReference? = nil
                                        
                                        
                                        //post sahibibini bilgilerini çekme
                                        
                                        let userUuid = String(Auth.auth().currentUser?.uid ?? "m")
                                        let postedBy = Firestore.firestore().collection("Users").document(userUuid)
                                        
                                        postedBy.getDocument { document, error in
                                            if let document = document , document.exists{
                                                
                                                let userData = document.data()
                                                
                                                 let PostedByName =  userData?["userName"]
                                                 let PostedBySurname =  userData?["userSurname"]
                                                 let PostedByUsername =  userData?["username"]
                                                 let PostedByUserPP = userData?["userProfilPhoto"]
                                                
                                                let firestorePost = [
                                                    "imageUrl" : imageUrl ,
                                                    "PostedBy" : Auth.auth().currentUser!.email! ,
                                                    "PostedByName" : PostedByName ,
                                                    "PostedBySurname" : PostedBySurname ,
                                                    "PostedByUserName" : PostedByUsername ,
                                                    "postComment" : self.textView.text! ,
                                                    "postedByUserPP" : PostedByUserPP ,

                                                    "date": FieldValue.serverTimestamp() ,
                                                    "likes" : 0] as [String : Any]
                                                
                                                firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost , completion: { error in
                                                    
                                                    if error != nil{
                                                      
                                                        self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                                        
                                                    }else{
                                                        self.imageView.image = UIImage(named: "select.png")
                                                        self.textView.text = ""
                                                        self.tabBarController?.selectedIndex = 0
                                                    }
                                                
                                                })

                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
            
        }
        
        
        
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
                self.username.text = postedByUsername
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

    
    
    
    func makeAlert(title : String , message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    
    
    
    
    
}
