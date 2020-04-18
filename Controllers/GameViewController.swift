//
//  GameViewController.swift
//  SudokuIOS
//
//  Created by Kent Nippard on 2020-04-12.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    @IBOutlet var labl : UILabel?
    @IBOutlet var sudokuCollectionView : UICollectionView?
    
    private var game: Game = Game()
    private var lastTouched: IndexPath = IndexPath(item: -1, section: 0)
    
    override func viewWillAppear(_ animated: Bool) {
        game.board = Board()
        game.player = Player()
        game.generateBoard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sudokuCollectionView?.layer.borderWidth = 2
        sudokuCollectionView?.layer.borderColor = UIColor.black.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    // button handler for the number pad
    @IBAction func pressNum(sender : UIButton) {
        // ensure a number pad button was pressed and a cell is selected
        if sender.tag >= 0 && sender.tag <= 9 && lastTouched.item >= 0 {
            // if the player touched the clear button
            if sender.tag == 0 {
                // set the cell to blank & reload the cell
                game.board?.setNumberAt(index: lastTouched.item, number: sender.tag)
                sudokuCollectionView?.reloadItems(at: [lastTouched])
                let cell = sudokuCollectionView?.cellForItem(at: lastTouched)
                cell?.backgroundColor = .green
                
                // set previous selected cell to none
                lastTouched.item = -1
            }
            else {
                // check if user's chosen number fits in the row, col, and segment
                let returnCode = game.checkIfValid(index: lastTouched.item, number: sender.tag)
                // if the choice is valid,
                if returnCode == 1 {
                    // set the cell to the number pressed & reload the cell
                    game.board?.setNumberAt(index: lastTouched.item, number: sender.tag)
                    sudokuCollectionView?.reloadItems(at: [lastTouched])
                    
                    // set the cell's background to mark the user's input
                    let cell = sudokuCollectionView?.cellForItem(at: lastTouched)
                    cell?.backgroundColor = .cyan
                    
                    // set previous selected cell to none
                    lastTouched.item = -1
                    
                    // end the game if the player has solved the puzzle
                    if game.checkIfSolved() {
                        labl?.text = "You win!"
                    }
                } else if returnCode == -1 {
                    labl?.text = "Number exists in row!"
                } else if returnCode == -2 {
                    labl?.text = "Number exists in column!"
                } else if returnCode == -3 {
                    labl?.text = "Number exists in segment!"
                }
            }
        } else {
            labl?.text = "No cell selected."
        }
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
    
    // define the content of each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // define the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as UICollectionViewCell
        
        // if cell is a given cell, colour it grey
        if game.isCellGiven(index: indexPath.item) {
            cell.backgroundColor = .lightGray
        }
        
        // if the cell is on the edge of a segment, thicken its border
//        if indexPath.item % 9 == 3
//        cell.layer.borderWidth = 1.0
        
        // define the label that will display the number on the cell
        let cellLabel = UILabel(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
        cellLabel.textAlignment = .center
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5
        
        // show the cell's number on the label unless it's 0 (then blank)
        if game.getBoard().getNumberAt(index: indexPath.item) > 0 {
            cellLabel.text = String(game.getBoard().getNumberAt(index: indexPath.item))
        } else {
            cellLabel.text = ""
        }
        
        // add the cell label to the cell
        cell.addSubview(cellLabel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // show the coord of the selected cell on a label
        let cord = game.getBoard().getCordinatesFromIndex(Index: (indexPath.item))
        labl?.text = "(\(cord.RowIndex),\(cord.ColIndex)): \(game.getBoard().getNumberAt(RowIndex: cord.RowIndex, ColIndex: cord.ColIndex))"
        
        // if selected cell is not a given cell
        if !game.isCellGiven(index: indexPath.item) {
            // if user selected a different cell before this,
            if lastTouched.item >= 0 {
                // get the previously selected cell
                let prevCell = sudokuCollectionView?.cellForItem(at: lastTouched)
                
                // if the previously selected cell has a value, reset to value colour
                if game.board!.getNumberAt(index: indexPath.item) > 0 {
                    prevCell?.backgroundColor = .cyan
                }
                // else, prev selected cell has no value, reset to base colour
                else {
                    prevCell?.backgroundColor = .green
                }
                
                // reset cell border to unselected width
                prevCell?.layer.borderWidth = 0.5
            }
            
            // highlight selected cell by changing background colour and border
            let touchedCell = sudokuCollectionView?.cellForItem(at: indexPath)
            touchedCell?.backgroundColor = .yellow
            touchedCell?.layer.borderWidth = 3.0
            
            // track the index path of the most recently touched cell
            lastTouched = indexPath
        }
    }
}
