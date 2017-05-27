//
//  ChatViewController.swift
//  TinderClone
//
//  Created by Arkadijs Makarenko on 27/05/2017.
//  Copyright © 2017 ArchieApps. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var chatTitleBar: UIButton!{
        didSet{
            chatTitleBar.tintColor = UIColor.red
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func backToTinder(_ sender: Any) {
         dismiss(animated: false, completion: nil)
    }


}
