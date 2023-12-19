//
//  profilPhotosSUViewController.swift
//  StartHub
//
//  Created by Mustafa Ölmezses on 28.11.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class profilPhotosSUViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
    }
                

    
    @objc func chooseImage(){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true)
        
    }
   
 
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("userProfilPhotos")
        
        
        
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
             
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

                                    
                                    self.performSegue(withIdentifier: "toHomeVC", sender: nil)
                                    
                                    
                                }
                         
                            }
     
                        }
 
                    }
                    
                }
                
            }
            
        }//fdsf
        
        
    }
    
    func makeAlert(title : String , message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
}
