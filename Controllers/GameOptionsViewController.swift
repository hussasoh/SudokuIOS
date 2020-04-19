//
//  GameOptionsViewController.swift
//  SudokuIOS
//
//  Created by Kent Nippard on 2020-04-13.
//  Copyright © 2020 Xcode User. All rights reserved.

// Author: Omar Kanawati

import UIKit

// sets game options before starting a new game (Omar Kanawati)
class GameOptionsViewController: UIViewController, UITextFieldDelegate {
    
    // get the app delegate
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // outlets for components of Game Options screen
    @IBOutlet var sgGameMode : UISegmentedControl!
    @IBOutlet var imgGameIcon : UIImageView!
    @IBOutlet var lblDescription : UILabel!
    @IBOutlet var sgBackground : UISegmentedControl!
    @IBOutlet var imgBackground : UIImageView!
    @IBOutlet var btnStartGame : UIButton!
    @IBOutlet var btnResumeGame : UIButton!
    
    var player: Player?
    
    // array that contains different game mode icons and background choices
    var imgData = ["sudoku_normal", "sudoku_timer", "sudoku_killer", "watercolor", "clouds"]

    var imgName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // sets default value for game mode
        imgGameIcon.image = UIImage(named: imgData[0])
        lblDescription.text = "Traditional Sudoku with a 9 x 9 grid."
        
        // sets default background image
        imgBackground.image = UIImage(named: imgData[3])
        
        // if unfinished game exists in userDefaults, show the resume button
        let gameProgress = mainDelegate.loadProgress()
        if gameProgress.board != nil {
            btnResumeGame.isHidden = false
        }
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
    
    // when the start game button is clicked
    @IBAction func btnStartGameWasClicked(sender: UIButton!) {
        // define alert to ask for player name
        let alert = UIAlertController(title: "Player Name", message: "Enter your name.", preferredStyle: .alert)
        
        // add a text field for the player's name
        alert.addTextField { (textField) in
            textField.text = "Your Name"
        }
        
        // define button to confirm the player's inputted name
        let actionNew = UIAlertAction(title: "Continue", style: .cancel, handler: { (_) in
            // get the name field from the alert
            let nameField: UITextField? = alert.textFields![0]
            // if the name field has text in it, save a player with it in app delegate
            if !nameField!.text!.isEmpty {
                self.mainDelegate.currentPlayer = Player.init(name: nameField!.text!)
            } else {
                self.mainDelegate.currentPlayer = Player.init(name: "Unnamed")
            }
            // now send the segue
            self.performSegue(withIdentifier: "startGameSegue", sender: nil)
        })
        
        // add the confirm action and present the alert
        alert.addAction(actionNew)
        self.present(alert, animated: true, completion: nil)
    }
    
    // when a segue has been initiated
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if player clicked the start game button
        if (segue.identifier == "startGameSegue") {
            // get the game view controller
            let gameVC = (segue.destination as! GameViewController)
            
            // generate a new board for the game VC and record the given cells
            gameVC.game.setBoard(board: Board())
            gameVC.game.recordGivenCells()
            
            // assign the current player to the game VC's game instance
            gameVC.game.setPlayer(player: mainDelegate.currentPlayer!)
        }
        // if player clicked the resume game button (which only appears if player has a saved game)
        else if segue.identifier == "resumeGameSegue" {
            // get the game view controller
            let gameVC = segue.destination as! GameViewController
            // get the saved game progress
            let gameProgress = mainDelegate.loadProgress()
            // delete the progress from storage now that it's loaded
            mainDelegate.deleteProgress()
            
            // assign the unfinished game to the game VC
            gameVC.game = gameProgress
        }
    }
}
