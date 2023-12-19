//
//  ProfilInfo.swift
//  StartHub
//
//  Created by Mustafa Ölmezses on 12.12.2023.
//

import UIKit

class ProfilInfo: UITableViewCell {
    
    
    @IBOutlet var userPP : UIImageView!
    @IBOutlet var userNameAndSurname : UILabel!
    @IBOutlet var userName : UILabel!
    @IBOutlet var date : UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userPostText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        userPP.layer.cornerRadius =  ((userPP.frame.size.width + userPP.frame.size.height) / 2) / 2
        userPP.clipsToBounds = true
        userImage.layer.cornerRadius = userImage.frame.size.width / 20
        userName.clipsToBounds = true
        userImage.contentMode = .scaleAspectFill
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
