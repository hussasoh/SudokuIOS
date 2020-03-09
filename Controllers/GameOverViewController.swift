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
    /*
        let activityVC = UIActivityViewController(activityItems: ["Score"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
*/
    
   // let alert = UIAlertController(title: "Share", message: "Share your Sudoko score on Facebook!", preferredStyle: .actionSheet)
    
       // let actionOne = UIAlertAction(title: "Share", style: .default ) { (action) in
        
    
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}


