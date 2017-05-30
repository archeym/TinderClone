//
//  FacebookLogin.swift
//  TinderClone
//
//  Created by Arkadijs Makarenko on 28/05/2017.
//  Copyright © 2017 ArchieApps. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import Firebase

extension LoginViewController : FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        self.indicatorStart()
        showInfo()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User logged out")
    }
    
    
    func showInfo() {
        let accessToken = FBSDKAccessToken.current()
        
        guard let accessTokenString = accessToken?.tokenString else {return}
        
        let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Something wrong with user error ", error!)
                return
            }
            
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "id, name, email, birthday, age_range, location, gender, work"]).start { (completion, result, err) in
                if err != nil {
                    print("Failed to graph request", err!)
                    return
                }
                
                if (result as? [String : Any]) != nil {
                    
                    let fbUserName = user!.displayName
                    let fbUserPhotoUrl = "\((user!.photoURL)!)"
                    guard let FBvalues : [String : Any] = ["name" : fbUserName ?? "Tinder User", "profileImageUrl" : fbUserPhotoUrl] else {return}
                    Database.database().reference().child("users").child((user?.uid)!).updateChildValues(FBvalues)
                    
                }
                
                self.registerButtonToNextVC()
            }
            print("Successfully logged in ", user!)
        })
    }
}
