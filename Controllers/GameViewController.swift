//
//  GameViewController.swift
//  SudokuIOS
//
//  Created by Kent Nippard on 2020-04-12.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    // get access to the app delegate
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // define VC outlet controls
    @IBOutlet var labl : UILabel!
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var sudokuCollectionView : UICollectionView!
    
    // define game and game options objects
    var game: Game = Game()
    var gameOptions: GameOptions = GameOptions()
    
    // cell data of last touched cell
    private var OldCell  = UICollectionViewCell()
    private var OldCellTextField = UITextField()
    private var OldCellCordinates = Cordinates(RowIndex: -1, ColIndex: -1)
    private var lastTouched: IndexPath = IndexPath(item: -1, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // give the collection view a black border
        sudokuCollectionView?.layer.borderWidth = 2
        sudokuCollectionView?.layer.borderColor = UIColor.black.cgColor
        
        // ensure cells coloured correctly
        doColourCells()
//        sudokuCollectionView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(OldCellCordinates.RowIndex != -1 && OldCellCordinates.ColIndex != -1){
            
            if(textField.text!.count != 0){
                let returnCode = game.checkIfValid(index: lastTouched.item, number: Int(textField.text!)!)
                if(returnCode == 1){
                    game.getBoard().setNumberAt(RowIndex: OldCellCordinates.RowIndex, ColIndex: OldCellCordinates.ColIndex, number: Int(String(textField.text!))!)
                    
                    OldCell.backgroundColor = .cyan
                    OldCell.layer.borderWidth = 0.5
                    
                    // if game board has been solved
                    if game.checkIfSolved() {
                        // save the score and display a win message
                        game.getPlayer().setScore(score: 0)
                        if mainDelegate.insertIntoDatabase(player: game.getPlayer()) {
                            lblMessage!.text = "You win! Score has been saved."
                        } else {
                            lblMessage!.text = "You win! Score could not be saved."
                        }
                    }
                } else if returnCode == -1 {
                    textField.text?.removeAll()
                    game.getBoard().setNumberAt(RowIndex: OldCellCordinates.RowIndex, ColIndex: OldCellCordinates.ColIndex, number: 0)
                    OldCell.backgroundColor = .green
                    OldCell.layer.borderWidth = 0.5
                    lblMessage.text = "Number exists in row!"
                } else if returnCode == -2 {
                    textField.text?.removeAll()
                    game.getBoard().setNumberAt(RowIndex: OldCellCordinates.RowIndex, ColIndex: OldCellCordinates.ColIndex, number: 0)
                    OldCell.backgroundColor = .green
                    OldCell.layer.borderWidth = 0.5
                    lblMessage.text = "Number exists in column!"
                } else if returnCode == -3 {
                    textField.text?.removeAll()
                    game.getBoard().setNumberAt(RowIndex: OldCellCordinates.RowIndex, ColIndex: OldCellCordinates.ColIndex, number: 0)
                    OldCell.backgroundColor = .green
                    OldCell.layer.borderWidth = 0.5
                    lblMessage.text = "Number exists in segment!"
                }
                else if( returnCode == -4){
                    textField.text? = OldCellTextField.text!
                    OldCell.backgroundColor = .cyan
                    OldCell.layer.borderWidth = 0.5
                    lblMessage.text = "This Number is already at this Location!"
                }
            }
            else{
                OldCell.backgroundColor = .green
                OldCell.layer.borderWidth = 0.5
            }
        }
        else {
            // flag the game as started if it isn't already
            if !game.isStarted() {
                game.setStarted(isStarted: true)
            }
        }
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
        return string == string.filter("0123456789".contains) && textField.text!.count < 1
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
        // show the coord of the selected cell on a label
        let cord = game.getBoard().getCordinatesFromIndex(Index: (indexPath.item))
        labl.text = "(\(cord.RowIndex),\(cord.ColIndex)): \(game.getBoard().getNumberAt(RowIndex: cord.RowIndex, ColIndex: cord.ColIndex))"
    
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
    
        // track the index path of the most recently touched cell
        lastTouched = indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if player is unwinding
        if segue.identifier == "unwindSegue" {
            // and if the game isn't finished
            if !self.game.isSolved() {
                // save the unfinished game
                mainDelegate.saveProgress(game: self.game)
                
                // show the resume button on game options screen
                let gameOptionsVC = segue.destination as! GameOptionsViewController
                gameOptionsVC.btnResumeGame.isHidden = false
            }
        }
    }
    
    // colour all user-entered cells
    func doColourUserCells() {
        // for all cells in grid
        for i in 0 ..< 9 * 9 {
            // if cell has a user-entered value, colour it
            if game.isStarted() && game.isUserCell(index: i) {
                let userCell = sudokuCollectionView.cellForItem(at: IndexPath(index: i))
                userCell?.backgroundColor? = .cyan
            }
        }
    }
    // colour all cells
    func doColourCells() {
        // for all cells in grid
        for i in 0 ..< 9 * 9 {
            // get the cell at this index
            let userCell = sudokuCollectionView.cellForItem(at: IndexPath(index: i))
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
