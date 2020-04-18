//
//  GameOptionsViewController.swift
//  SudokuIOS
//
//  Created by Kent Nippard on 2020-04-13.
//  Copyright © 2020 Xcode User. All rights reserved.


import UIKit

// sets game options before starting a new game (Omar Kanawati)
class GameOptionsViewController: UIViewController, UITextFieldDelegate {
    
    // instantiate app delegate object
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // outlets for components of Game Options screen
    @IBOutlet var sgGameMode : UISegmentedControl!
    @IBOutlet var imgGameIcon : UIImageView!
    @IBOutlet var lblDescription : UILabel!
    @IBOutlet var sgBackground : UISegmentedControl!
    @IBOutlet var imgBackground : UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sets default value for game mode
        imgGameIcon.image = UIImage(named: mainDelegate.imgData[0])
        lblDescription.text = "An easier challenge with fewer missing numbers"
        
        // sets default background image
        imgBackground.image = UIImage(named: mainDelegate.imgData[3])

        // sets default options in option set
        mainDelegate.gameOptions.insert(.easy)
        mainDelegate.gameOptions.insert(.background1)
        
        
    }
    
    // allow user to unwind with the back button from segued pages
    @IBAction func unwindToHomeVC(sender: UIStoryboardSegue) {}
    
    // changes the game mode icon and description depending on selection in segmented control
    func selectGameMode() {
        if (sgGameMode.selectedSegmentIndex == 0) {
            imgGameIcon.image = UIImage(named: mainDelegate.imgData[0])
            lblDescription.text = "An easier challenge with fewer missing numbers"
            
        }
        else if (sgGameMode.selectedSegmentIndex == 1) {
            imgGameIcon.image = UIImage(named: mainDelegate.imgData[1])
            lblDescription.text = "Tradition sudoku to offer a moderate challenge"
        }
        else {
            imgGameIcon.image = UIImage(named: mainDelegate.imgData[2])
            lblDescription.text = "Master the game with the fewest filled in squares!"
        }
    
    }
    
    // change the background image for the game
    func selectBackground() {
        if (sgBackground.selectedSegmentIndex == 0) {
            imgBackground.image = UIImage(named: mainDelegate.imgData[3])
            
    
            mainDelegate.gameOptions.insert(.background1)
            mainDelegate.gameOptions.remove(.background2)
            
        }
        else {
            imgBackground.image = UIImage(named: mainDelegate.imgData[4])
            mainDelegate.gameOptions.insert(.background2)
            mainDelegate.gameOptions.remove(.background1)
        }
    }
    
    // updates the game mode icon and description when segmented control is clicked
    @IBAction func modeValueChange(sender : UISegmentedControl) {
        selectGameMode()
    }
    
    // updates the selected background
    @IBAction func backgroundValueChange(sender : UISegmentedControl) {
        selectBackground()
    }
    
    
}
