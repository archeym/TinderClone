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
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func logoutButton(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let currentStoryboard = UIStoryboard (name: "Auth", bundle: Bundle.main)
        let initController = currentStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
        present(initController, animated: true, completion: nil)
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

    }
    
    @IBAction func backToTinder(_ sender: Any) {
        dismiss(animated: false, completion: nil)
        //navigationController?.popToRootViewController(animated: true)
    }

}
