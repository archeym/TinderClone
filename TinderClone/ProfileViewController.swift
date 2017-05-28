//
//  ProfileViewController.swift
//  TinderClone
//
//  Created by Arkadijs Makarenko on 27/05/2017.
//  Copyright © 2017 ArchieApps. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var editPhoto: UIButton!
    @IBOutlet weak var imageView: UIImageView!{
        didSet{
            imageView.layer.cornerRadius = imageView.frame.height/2
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    var profileImage : String? = ""
    var profileRating : String? = ""
    
    var currentUserID = Auth.auth().currentUser?.uid
    var currentUser : User? = Auth.auth().currentUser

    
    @IBAction func logoutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let currentStoryboard = UIStoryboard (name: "Auth", bundle: Bundle.main)
        let initController = currentStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
        present(initController, animated: true, completion: nil)
    }
    
    func listenToFirebase() {
        Database.database().reference().child("users").child(currentUserID!).observe(.value, with: { (snapshot) in
            let dictionary = snapshot.value as? [String : Any]
            self.nameLabel.text = dictionary?["name"] as? String
            self.emailLabel.text = dictionary?["email"] as? String
            self.profileImage = dictionary?["profileImageUrl"] as? String
            
            if let profileURL = self.profileImage {
                self.imageView.loadImageUsingCacheWithUrlString(profileURL)
                self.imageView.circlerImage()
            }
        })
    }
    
    @IBAction func editInfoButton(_ sender: Any) {
    }
    
    
    @IBOutlet weak var user: UIButton!{
        didSet{
            user.tintColor = UIColor.red
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        listenToFirebase()

    }
    
    @IBAction func backToTinder(_ sender: Any) {
        dismiss(animated: false, completion: nil)
        //navigationController?.popToRootViewController(animated: true)
    }

}
