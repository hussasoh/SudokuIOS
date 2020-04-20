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
    @IBOutlet var sgGameMode : UISegmentedControl!      // the game mode segmented control
    @IBOutlet var imgGameIcon : UIImageView!            // the game icon
    @IBOutlet var lblDescription : UILabel!             // the description of the selected mode
    @IBOutlet var sgBackground : UISegmentedControl!    // the background segmented control
    @IBOutlet var imgBackground : UIImageView!          // the background image view
    @IBOutlet var btnStartGame : UIButton!              // the start game button
    @IBOutlet var btnResumeGame : UIButton!             // the resume game button
    
    // array that contains different game mode icons and background choices
    var imgData = ["sudoku_normal", "sudoku_timer", "sudoku_killer", "watercolor", "clouds"]

    var imgName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sets default value for game mode
        imgGameIcon.image = UIImage(named: mainDelegate.imgData[0])
        lblDescription.text = "An easier challenge with fewer missing numbers"
        
        // sets default background image
        imgBackground.image = UIImage(named: mainDelegate.imgData[3])
        
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
            imgGameIcon.image = UIImage(named: mainDelegate.imgData[0])
            lblDescription.text = "An easier challenge with fewer missing numbers"
            
            clearGameModeOptions()
            mainDelegate.gameOptions.insert(.easy)
            
        }
        else if (sgGameMode.selectedSegmentIndex == 1) {
            imgGameIcon.image = UIImage(named: mainDelegate.imgData[1])
            lblDescription.text = "Tradition sudoku to offer a moderate challenge"
            
            clearGameModeOptions()
            mainDelegate.gameOptions.insert(.normal)
        }
        else {
            imgGameIcon.image = UIImage(named: mainDelegate.imgData[2])
            lblDescription.text = "Master the game with the fewest filled in squares!"
            
            clearGameModeOptions()
            mainDelegate.gameOptions.insert(.hard)
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
    
    // clears all game mode options from set
    func clearGameModeOptions() {
        mainDelegate.gameOptions.remove(.easy)
        mainDelegate.gameOptions.remove(.normal)
        mainDelegate.gameOptions.remove(.hard)
    }
    
    /* PREPARING THE GAME VIEW CONTROLLER */
    
    // Author: Terry Nippard
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
    
    // Author: Terry Nippard
    // when a segue has been initiated
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if player clicked the start game button
        if (segue.identifier == "startGameSegue") {
            // get the game view controller
            let gameVC = (segue.destination as! GameViewController)
            
            // generate a new board for the game VC and record the given cells
            gameVC.game.setBoard(board: Board())
            gameVC.game.generateBoard()
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
