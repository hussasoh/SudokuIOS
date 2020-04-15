//
//  GameOverViewController.swift
//  SudokuIOS
//
//  Created by Xcode User on 2020-03-08.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookShare
import FacebookLogin
import Social


class GameOverViewController: UIViewController {
    
    
    
    @IBAction func buttonAction(_sender: Any) {
        shareOnSocial(serviceType: SLServiceTypeFacebook, score: "score")
        
        }
    
    
    
 
        

    override func viewDidLoad() {
        
            
        let loginButton = FBLoginButton(permissions: [ .publicProfile ])
        
            loginButton.center = view.center
            
            view.addSubview(loginButton)
        

        // Do any additional setup after loading the view.
    }
    
    func shareOnSocial(serviceType: String, score: String) {
        if SLComposeViewController.isAvailable(forServiceType: serviceType) {
            guard let view = SLComposeViewController(forServiceType: serviceType) else {
                return
            }
            //view.add(URL(string: score ))
            view.setInitialText("iOS Tutorials: Share on Facebook, LinkedIn, Google Plus with SLComposeViewController")
            self.present(view, animated: true, completion: nil)
        } else {
            // Account not set up
        }
    }
    
}


