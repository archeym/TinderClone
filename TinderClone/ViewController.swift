//
//  ViewController.swift
//  TinderClone
//
//  Created by Arkadijs Makarenko on 26/05/2017.
//  Copyright © 2017 ArchieApps. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var girlsView: UIView!
    @IBOutlet weak var nopeImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    
    var dividor : CGFloat!
    
    @IBAction func logoutButton(_ sender: Any) {
        handleLogout()
        
    }
    @IBAction func refreshView(_ sender: Any) {
        refreshGirls()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //girlsView.layer.cornerRadius = 10
    
        dividor = (view.frame.width / 2) / 0.61 //0.61 is radian value of 35 degree
        
    }
    
    func handleLogout(){
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let currentStoryboard = UIStoryboard (name: "Auth", bundle: Bundle.main)
        let initController = currentStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
        present(initController, animated: true, completion: nil)
    }
    
    @IBAction func handleSwipe(_ sender: UIPanGestureRecognizer) {
        let girls = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = girls.center.x - view.center.x
        let scale = min(abs(100 / xFromCenter) , 1)
        girls.center = CGPoint(x: view.center.x + point.x , y: view.center.y + point.y)
        girls.transform = CGAffineTransform(rotationAngle: xFromCenter/dividor).scaledBy(x: scale, y: scale) // for scaling anything less than 1 will make the object smaller
        
        if xFromCenter > 0 {
            likeImageView.image = #imageLiteral(resourceName: "like")
            likeImageView.tintColor = UIColor.green
            likeImageView.alpha = abs(xFromCenter) / view.center.x
        }else{
            nopeImageView.image = #imageLiteral(resourceName: "nope")
            nopeImageView.tintColor = UIColor.red
            nopeImageView.alpha = abs(xFromCenter) / view.center.x
        }
        //thumbImageView.alpha = abs(xFromCenter) / view.center.x
        if sender.state == .ended{
            // setting a mergins to 75 to animate
            if girls.center.x < 75 {
                // the view should move to the left
                UIView.animate(withDuration: 0.2, animations: {
                    girls.center = CGPoint(x: girls.center.x - 200, y: girls.center.y + 75)
                    girls.alpha = 0
                })
                return
                
            }else if girls.center.x > (view.frame.width - 75){
                // the view should move to the right
                UIView.animate(withDuration: 0.2, animations: {
                    girls.center = CGPoint(x: girls.center.x + 200, y: girls.center.y + 75)
                    girls.alpha = 0
                })
                return
            }
            refreshGirls()
        }
    }
    func refreshGirls(){
        self.girlsView.center = self.view.center
        self.likeImageView.alpha = 0
        self.nopeImageView.alpha = 0
        self.girlsView.alpha = 1
        self.girlsView.transform = .identity
    }
    
}

