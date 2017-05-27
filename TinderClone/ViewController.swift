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

    @IBOutlet weak var segmentedController: UISegmentedControl!{
        didSet{
            
            segmentedController.backgroundColor = UIColor.clear
            segmentedController.tintColor = UIColor.red
            
            
        }
    }
    @IBOutlet weak var girlsView: UIView!
    @IBOutlet weak var nopeImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    
    @IBOutlet weak var profileBarTab: UIBarButtonItem!
    
    var dividor : CGFloat!

    @IBAction func refreshView(_ sender: Any) {
        refreshGirls()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        dividor = (view.frame.width / 2) / 0.61
    }
    
    @IBAction func goToProfileVC(_ sender: Any) {
        let currentStoryboard = UIStoryboard (name: "Main", bundle: Bundle.main)
        let initController = currentStoryboard.instantiateViewController(withIdentifier: "ProfileNavigation")
        present(initController, animated: true, completion: nil)
    }
    
    @IBAction func goToChatVC(_ sender: Any) {
        let currentStoryboard = UIStoryboard (name: "Main", bundle: Bundle.main)
        let initController = currentStoryboard.instantiateViewController(withIdentifier: "ChatNavigation")
        present(initController, animated: true, completion: nil)
    }
    
    
    @IBAction func handleSwipe(_ sender: UIPanGestureRecognizer) {
        let girlCard = sender.view!
        let point = sender.translation(in: view)
        
        let xFromCenter = girlCard.center.x - view.center.x
        let scale = min(abs(100 / xFromCenter) , 1)
        
        girlCard.center = CGPoint(x: view.center.x + point.x , y: view.center.y + point.y)
        girlCard.transform = CGAffineTransform(rotationAngle: xFromCenter/dividor).scaledBy(x: scale, y: scale) // for scaling anything less than 1 will make the object smaller
        
        if xFromCenter > 0 {
            likeImageView.image = #imageLiteral(resourceName: "like")
            likeImageView.tintColor = UIColor.green
            likeImageView.alpha = abs(xFromCenter) / view.center.x
        }else{
            nopeImageView.image = #imageLiteral(resourceName: "nope")
            nopeImageView.tintColor = UIColor.red
            nopeImageView.alpha = abs(xFromCenter) / view.center.x
        }
        
        if sender.state == .ended{
            // setting animation, a mergins to 75
            if girlCard.center.x < 75 {
                // move off to the left
                UIView.animate(withDuration: 0.4, animations: {
                    girlCard.center = CGPoint(x: girlCard.center.x - 200, y: girlCard.center.y + 75)
                    girlCard.alpha = 0
                })
                return
                
            }else if girlCard.center.x > (view.frame.width - 75){
                // the view should move to the right
                UIView.animate(withDuration: 0.4, animations: {
                    girlCard.center = CGPoint(x: girlCard.center.x + 200, y: girlCard.center.y + 75)
                    girlCard.alpha = 0
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

