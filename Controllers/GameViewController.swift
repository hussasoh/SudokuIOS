//
//  GameViewController.swift
//  SudokuIOS
//
//  Created by Kent Nippard on 2020-04-12.
//  Copyright © 2020 Xcode User. All rights reserved.
//

// Author: Sohaib Hussain

import UIKit

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    // get access to the app delegate
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate

    // define VC outlet controls
    @IBOutlet var warningLabl : UILabel?
    @IBOutlet var timerLbl: UILabel?
    @IBOutlet var sudokuCollectionView : UICollectionView?
    @IBOutlet var background : UIImageView?
    
    // define game and game options objects
    var game: Game = Game()
    var gameOptions: GameOptions = GameOptions()
    
    // cell data of last touched cell
    private var OldCell  = UICollectionViewCell()
    private var OldCellTextField = UITextField()
    private var OldCellCordinates = Cordinates(RowIndex: -1, ColIndex: -1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // give the collection view a black border
        sudokuCollectionView?.layer.borderWidth = 2
        sudokuCollectionView?.layer.borderColor = UIColor.black.cgColor
        
        self.doColourCells()
        
        // change background to options background
        if (mainDelegate.gameOptions.contains(.background1)) {
            background?.image = UIImage(named: mainDelegate.imgData[3])
        }
        else {
            background?.image = UIImage(named: mainDelegate.imgData[4])
        }
    }
    
    // Author: Terry Nippard
    // when user dismisses the keyboard (having entered a value into cell)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // if a cell has been selected
        if(OldCellCordinates.RowIndex != -1 && OldCellCordinates.ColIndex != -1){
            // if there is a text field in the cell
            if(textField.text!.count != 0){
                // get the number at the index of the cell
                let itemNumber = game.board?.getIndexFromCordinates(RowIndex: OldCellCordinates.RowIndex, ColIndex: OldCellCordinates.ColIndex)
                
                // check if the player's selected number placement is valid
                let returnCode = game.checkIfValid(index: itemNumber!, number: Int(String(textField.text!))!,initialize: false)
                
                // if player's selected number is valid,
                if(returnCode == 1){
                    // play sound effect
                    if (mainDelegate.menuOptions.getEffectsOn() == true){
                        mainDelegate.soundPlayer?.play()
                    }
                    
                    // set the user's selected number in the board array corresponding to cell
                    game.getBoard().setNumberAt(RowIndex: OldCellCordinates.RowIndex, ColIndex: OldCellCordinates.ColIndex, number: Int(textField.text!)!)
                    
                    // set the cell colour to indicate it was user-inputted
                    OldCell.backgroundColor = .cyan
                    OldCell.layer.borderWidth = 0.5
                    
                    // if game board has been solved
                    if game.checkIfSolved() {
                         game.setStarted(isStarted: false)
                        // save the score and display a win message
                        game.getPlayer().setScore(score: 0)
                        if mainDelegate.insertIntoDatabase(player: game.getPlayer()) {
                            warningLabl!.text = "You win! Score has been saved."
                        } else {
                            warningLabl!.text = "You win! Score could not be saved."
                        }
                    }
                // else if the number already exists in row of selected cell
                } else if returnCode == -1 {
                    // cancel the selection
                    textField.text?.removeAll()
                    // set value to 0 (unselected value)
                    game.getBoard().setNumberAt(RowIndex: OldCellCordinates.RowIndex, ColIndex: OldCellCordinates.ColIndex, number: 0)
                    // give cell its default appearance
                    OldCell.backgroundColor = .green
                    OldCell.layer.borderWidth = 0.5
                    // show warning message
                    warningLabl?.text = "Number exists in row!"
                }
                // else if the number already exists in column of selected cell
                else if returnCode == -2 {
                    // cancel the selection
                    textField.text?.removeAll()
                    // set value to 0 (unselected value)
                    game.getBoard().setNumberAt(RowIndex: OldCellCordinates.RowIndex, ColIndex: OldCellCordinates.ColIndex, number: 0)
                    // give cell its default appearance
                    OldCell.backgroundColor = .green
                    OldCell.layer.borderWidth = 0.5
                    // show warning message
                    warningLabl?.text = "Number exists in column!"
                }
                // else if the number already exists in segment of selected cell
                else if returnCode == -3 {
                    // cancel the selection
                    textField.text?.removeAll()
                    // set value to 0 (unselected value)
                    game.getBoard().setNumberAt(RowIndex: OldCellCordinates.RowIndex, ColIndex: OldCellCordinates.ColIndex, number: 0)
                    // give cell its default appearance
                    OldCell.backgroundColor = .green
                    OldCell.layer.borderWidth = 0.5
                    // show warning message
                    warningLabl?.text = "Number exists in segment!"
                }
                // else if the number already exists in the location of selected cell
                else if( returnCode == -4){
                    // cancel the selection
                    textField.text? = OldCellTextField.text!
                    // set value to 0 (unselected value)
                    game.getBoard().setNumberAt(RowIndex: OldCellCordinates.RowIndex, ColIndex: OldCellCordinates.ColIndex, number: 0)
                    // give cell its default appearance
                    OldCell.backgroundColor = .cyan
                    OldCell.layer.borderWidth = 0.5
                    // show warning message
                    warningLabl?.text = "This Number is already at this Location!"
                }
            }
            else {
                // give selected cell its default appearance
                OldCell.backgroundColor = .green
                OldCell.layer.borderWidth = 0.5
            }
        }
        else {
            // flag the game as started if it isn't already
            if !game.isStarted() {
                game.setStarted(isStarted: true)
            }
            
            Timer.scheduledTimer(withTimeInterval: 1.0,
                                 repeats: true,
                                 block: {_ in
                                    let secs = String(format: "%02d",self.game.seconds)
                                    let mins = String(format: "%02d",self.game.minutes)
                                    let hrs = String(format: "%02d",self.game.hour)
                                    self.timerLbl?.text = "Timer: \(hrs): \(mins): \(secs)"
            })
        }
    
        // dismiss the keyboard
        return textField.resignFirstResponder()
    }
    
    // define dimensions of each cell to fit 9x9 on grid
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: ((sudokuCollectionView?.frame.size.width)!)/9,
            height: ((sudokuCollectionView?.frame.size.height)!)/9)
    }
    
    // set cells to have no spacing horizontally
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // set cells to have no spacing vertically
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // define the total number of cells on the grid
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (game.getBoard().getBoard2dArray().count * game.getBoard().getBoard2dArray()[0].count)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                textField.text?.removeAll()
            }
        }
        return string == string.filter("123456789".contains) && textField.text!.count < 1
    }
    
    // define the content of each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // define the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as UICollectionViewCell
        
        // define the label that will display the number on the cell
        let cellTextField = UITextField(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
        cellTextField.textAlignment = .center
        cellTextField.delegate = self
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5
        
        // if cell is a given cell, colour it grey
        if game.isCellGiven(index: indexPath.item) {
            cell.backgroundColor = .lightGray
            cell.isUserInteractionEnabled = false
        }
        // else if cell already has a user-entered value, colour it blue
        else if game.isStarted() && game.isUserCell(index: indexPath.item) {
            cell.backgroundColor = .cyan
        }
        
        //disables the textfield for editing
        cellTextField.isEnabled = false
        cellTextField.tag = (indexPath.item + 5)
        
        // show the cell's number on the label unless it's 0 (then blank)
        if game.getBoard().getNumberAt(index: indexPath.item) > 0 {
            cellTextField.text = String(game.getBoard().getNumberAt(index: indexPath.item))
        } else {
            cellTextField.text = ""
        }
        
        // add the cell label to the cell
        cell.addSubview(cellTextField)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // play sound effect
        if (mainDelegate.menuOptions.getEffectsOn() == true){
            mainDelegate.soundPlayer?.play()
        }
        
        // show the coord of the selected cell on a label
        let cord = game.getBoard().getCordinatesFromIndex(Index: (indexPath.item))
        warningLabl?.text = "(\(cord.RowIndex),\(cord.ColIndex)): \(game.getBoard().getNumberAt(RowIndex: cord.RowIndex, ColIndex: cord.ColIndex))"
    
        var _ = textFieldShouldReturn(OldCellTextField)
        OldCellTextField.isEnabled = false
    
        // highlight selected cell by changing background colour and border
        let touchedCell = sudokuCollectionView?.cellForItem(at: indexPath)
        let textfield = touchedCell?.viewWithTag(indexPath.item + 5) as! UITextField
    
        textfield.isEnabled = true
        textfield.becomeFirstResponder()
        touchedCell?.backgroundColor = .yellow
        touchedCell?.layer.borderWidth = 3.0
    
        OldCell = touchedCell!
        OldCellTextField = textfield
        OldCellCordinates = cord
    }

    // Author: Terry Nippard
    // prepare for unwinding (save the game)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // and if the game isn't finished
        if !self.game.isSolved() {
            // save the unfinished game
            mainDelegate.saveProgress(game: self.game)
            
            // show the resume button on game options screen
            let gameOptionsVC = segue.destination as! GameOptionsViewController
            gameOptionsVC.btnResumeGame.isHidden = false
        }
    }
    
    // Author: Terry Nippard
    // colour all cells (for debug)
    func doColourCells() {
        // for all cells in grid
        for i in 0 ..< 9 * 9 {
            // get the cell at this index
            let userCell = sudokuCollectionView!.cellForItem(at: IndexPath(index: i))
            // if cell has a given value, colour it
            if game.isCellGiven(index: i) {
                userCell?.backgroundColor? = .lightGray
            }
            // if cell has a user-entered value, colour it
            else if game.isStarted() && game.isUserCell(index: i) {
                userCell?.backgroundColor? = .cyan
            }
            // else, cells will be green by default
        }
    }
}
