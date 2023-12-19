//
//  SettingsProfilePhotoViewController.swift
//  StartHub
//
//  Created by Mustafa Ölmezses on 18.12.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class SettingsProfilePhotoViewController: UIViewController ,UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    
    @IBOutlet var ExPhoto : UIImageView!
    @IBOutlet var NewPhoto : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ExPhoto.layer.cornerRadius =  ((ExPhoto.frame.size.width + ExPhoto.frame.size.height) / 2) / 2
        ExPhoto.clipsToBounds = true
        NewPhoto.layer.cornerRadius =  ((NewPhoto.frame.size.width + NewPhoto.frame.size.height) / 2) / 2
        NewPhoto.clipsToBounds = true
        
        NewPhoto.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        NewPhoto.addGestureRecognizer(gestureRecognizer)
        
        let userUuid = String(Auth.auth().currentUser?.uid ?? "m")
        let postedBy = Firestore.firestore().collection("Users").document(userUuid)
        
        postedBy.getDocument { document, error in
            if let document = document, document.exists {
                let userData = document.data()
                let exPhoto = userData?["userProfilPhoto"] as? String ?? "olmadı"
                
                
                
                self.ExPhoto.sd_setImage(with: URL(string: exPhoto))
                
                
                
            }else{
                self.makeAlert(title: "Eeeoe", message: "Eeeoe")
            }
        }
        
        
    }
    
    @objc func chooseImage(){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        NewPhoto.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true)
        
    }
    
    func makeAlert(title : String , message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("userProfilPhotos")
        
        
        
        
        if let data = NewPhoto.image?.jpegData(compressionQuality: 0.5){
            
            let userId = Auth.auth().currentUser?.uid
            let imageReference = mediaFolder.child("\(userId ?? "ımage").jpg")
            imageReference.putData(data, metadata: nil) { metadata, error in
                
                if error != nil {
                    self.makeAlert(title: "Error", message: "66")
                }else{
                    
                    imageReference.downloadURL { url, error in
                        
                        if error != nil{
                            self.makeAlert(title: "Error", message: "72")
                        }else{
                            let imageURL = url?.absoluteString
                            
                            
                            //DATABASE
                            
                            let db = Firestore.firestore()
                            
                            let documentId = userId
                            
                            let documentReference = db.collection("Users").document(documentId!)
                            
                            documentReference.updateData(["userProfilPhoto" : imageURL!]) { error in
                                
                                if error != nil {
                                    self.makeAlert(title: "Error", message: "91")
                                    
                                }else{
                                    
                                    self.makeAlert(title: "Succes", message: "Profil Photo Changedd")
                                    
                                    
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
        }
    }
}
