//
//  ViewController.swift
//  SudokuIOS
//
//  Created by Xcode User on 2020-03-03.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // instantiate app delegate object
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sets the game options once the application has loaded
        mainDelegate.gameOptions.insert(.easy)
        mainDelegate.gameOptions.insert(.background1)
    
        
        // Do any additional setup after loading the view.
    }
    
    // allow user to unwind with the back button from segued pages
    @IBAction func unwindToHomeVC(sender: UIStoryboardSegue) { }
}

