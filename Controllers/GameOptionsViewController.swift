//
//  GameOptionsViewController.swift
//  SudokuIOS
//
//  Created by Kent Nippard on 2020-04-13.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class GameOptionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // allow user to unwind with the back button from segued pages
    @IBAction func unwindToHomeVC(sender: UIStoryboardSegue) { }
}
