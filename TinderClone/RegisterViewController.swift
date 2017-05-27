//
//  RegisterViewController.swift
//  TinderClone
//
//  Created by Arkadijs Makarenko on 27/05/2017.
//  Copyright © 2017 ArchieApps. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate  {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self

    }
    func indicatorStart(){
        activityIndicator.center = self.view.center
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    @IBAction func backToLogin(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        handleRegister()
    }
    
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        if email == "" || password == "" || name == "" {
            warningPopUp(withTitle: "Input Error", withMessage: "Name, Email or Password Can't Be Empty")
            return
        }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                self.warningPopUp(withTitle: "Input Error", withMessage: "Email or Password Form is not Valid")
                return
            }
            self.registerButtonToNextVC()
            guard let uid = user?.uid else {
                return
            }
            
            let values = ["name": name, "email": email] as [String : Any]
            self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
        })
    }
    func registerUserIntoDatabaseWithUID(uid : String, values: [String: Any]) {
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
        })
    }
    
    func registerButtonToNextVC(){
        let currentStoryboard = UIStoryboard (name: "Main", bundle: Bundle.main)
        
        let initController = currentStoryboard.instantiateViewController(withIdentifier: "ViewController")
        activityIndicator.stopAnimating()
        present(initController, animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

}//end
extension UIViewController{
    func warningPopUp(withTitle title : String?, withMessage message : String?){
        let popUP = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        popUP.addAction(okButton)
        present(popUP, animated: true, completion: nil)
    }
}
