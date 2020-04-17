//
//  GameOptionsViewController.swift
//  SudokuIOS
//
//  Created by Kent Nippard on 2020-04-13.
//  Copyright © 2020 Xcode User. All rights reserved.


import UIKit

// sets game options before starting a new game (Omar Kanawati)
class GameOptionsViewController: UIViewController, UITextFieldDelegate {
    
    // outlets for components of Game Options screen
    @IBOutlet var sgGameMode : UISegmentedControl!
    @IBOutlet var imgGameIcon : UIImageView!
    @IBOutlet var lblDescription : UILabel!
    @IBOutlet var sgBackground : UISegmentedControl!
    @IBOutlet var imgBackground : UIImageView!
    
    // array that contains different game mode icons and background choices
    var imgData = ["sudoku_normal.png", "sudoku_timer.png", "sudoku_killer.png", "watercolor.jpg", "clouds.jpg"]
    var imgName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sets default value for game mode
        imgGameIcon.image = UIImage(named: imgData[0])
        lblDescription.text = "Traditional Sudoku with a 9 x 9 grid."
        
        // sets default background image
        imgBackground.image = UIImage(named: imgData[3])
        
        // Do any additional setup after loading the view.
    }
    
    // allow user to unwind with the back button from segued pages
    @IBAction func unwindToHomeVC(sender: UIStoryboardSegue) { }
    
    // changes the game mode icon and description depending on selection in segmented control
    func selectGameMode() {
        if (sgGameMode.selectedSegmentIndex == 0) {
            imgGameIcon.image = UIImage(named: imgData[0])
            lblDescription.text = "Traditional Sudoku with a 9 x 9 grid."
        }
        else if (sgGameMode.selectedSegmentIndex == 1) {
            imgGameIcon.image = UIImage(named: imgData[1])
            lblDescription.text = "Master the game to get the best time!"
        }
        else {
            imgGameIcon.image = UIImage(named: imgData[2])
            lblDescription.text = "The sum of all numbers in a cage must match the small number in its corner. No number appears more than once in a cage."
        }
    
    }
    
    // change the background image for the game
    func selectBackground() {
        if (sgBackground.selectedSegmentIndex == 0) {
            imgBackground.image = UIImage(named: imgData[3])
        }
        else {
            imgBackground.image = UIImage(named: imgData[4])
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
