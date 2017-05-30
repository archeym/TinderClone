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
    
    @IBOutlet weak var carusellLabel: UILabel!
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
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    var profileImage : String? = ""
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
            self.profileImage = dictionary?["profileImageUrl"] as? String
            
            if let profileURL = self.profileImage {
                self.imageView.loadImageUsingCacheWithUrlString(profileURL)
                self.imageView.circlerImage()
            }
        })
    }
    func loginScrollView(){
        self.scrollView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.width/1.1)
     
        
        carusellLabel.textAlignment = .center
        carusellLabel.text = "Discover new and interesting people nearby"
        carusellLabel.textColor = .black
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width*4, height: self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
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
        loginScrollView()

    }
    
    @IBAction func backToTinder(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }

}
extension ProfileViewController :  UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        self.pageControl.currentPage = Int(currentPage);
        if Int(currentPage) == 0{
            carusellLabel.text = "Discover new and interesting people nearby"
        }else if Int(currentPage) == 1{
            carusellLabel.text = "Swipe Right to anonymously like someone or Swipe left to pass"
        }else if Int(currentPage) == 2{
            carusellLabel.text = "If they also Swipe Right, it's a Match!"
        }else{
            carusellLabel.text = "Only people you've matched with can message you"
            
        }
    }
}
