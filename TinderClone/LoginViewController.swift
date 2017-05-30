//
//  LoginViewController.swift
//  TinderClone
//
//  Created by Arkadijs Makarenko on 26/05/2017.
//  Copyright © 2017 ArchieApps. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit


class LoginViewController: UIViewController {

    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginScrollView()
        
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    func loginScrollView(){
        self.scrollView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.width/1.1)
        let scrollViewHeight = self.scrollView.frame.height
        let scrollViewWidth = self.scrollView.frame.width
        
        textLabel.textAlignment = .center
        textLabel.text = "Discover new and interesting people nearby"
        textLabel.textColor = .black
        
        let imageOne = UIImageView(frame: CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight))
        let imageTwo = UIImageView(frame: CGRect(x: scrollViewWidth, y: 0, width: scrollViewWidth, height: scrollViewHeight))
        let imageThree = UIImageView(frame: CGRect(x: scrollViewWidth*2, y: 0, width: scrollViewWidth, height: scrollViewHeight))
        let imageFour = UIImageView(frame: CGRect(x: scrollViewWidth*3, y: 0, width: scrollViewWidth, height: scrollViewHeight))
        
        imageOne.image = UIImage(named: "imaga1")
        imageOne.layer.cornerRadius = 15
        imageOne.layer.masksToBounds = true
        imageTwo.image = UIImage(named: "imaga2")
        imageTwo.layer.cornerRadius = 15
        imageTwo.layer.masksToBounds = true
        imageThree.image = UIImage(named: "imaga3")
        imageThree.layer.cornerRadius = 15
        imageThree.layer.masksToBounds = true
        imageFour.image = UIImage(named: "imaga4")
        imageFour.layer.cornerRadius = 15
        imageFour.layer.masksToBounds = true
        
        self.scrollView.addSubview(imageOne)
        self.scrollView.addSubview(imageTwo)
        self.scrollView.addSubview(imageThree)
        self.scrollView.addSubview(imageFour)
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width*4, height: self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0

    }

    @IBOutlet weak var fb: FBSDKLoginButton!{
        didSet{
            fb.delegate = self
            fb.readPermissions = ["email", "public_profile"]
        }
    }

    func registerButtonToNextVC(){
        let currentStoryboard = UIStoryboard (name: "Main", bundle: Bundle.main)
        
        let initController = currentStoryboard.instantiateViewController(withIdentifier: "Navigation")
        activityIndicator.stopAnimating()
        present(initController, animated: true, completion: nil)
    }

    func indicatorStart(){
        activityIndicator.center = self.view.center
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    
}//end

extension LoginViewController :  UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        self.pageControl.currentPage = Int(currentPage);
        if Int(currentPage) == 0{
            textLabel.text = "Discover new and interesting people nearby"
        }else if Int(currentPage) == 1{
            textLabel.text = "Swipe Right to anonymously like someone or Swipe left to pass"
        }else if Int(currentPage) == 2{
            textLabel.text = "If they also Swipe Right, it's a Match!"
        }else{
            textLabel.text = "Only people you've matched with can message you"
            
        }
    }
}
