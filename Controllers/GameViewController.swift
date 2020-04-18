//
//  GameViewController.swift
//  SudokuIOS
//
//  Created by Kent Nippard on 2020-04-12.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    @IBOutlet var warningLabl : UILabel?
    @IBOutlet var timerLbl: UILabel?
    @IBOutlet var sudokuCollectionView : UICollectionView?
    
    //saves the status of the current game
    @IBAction func SaveGame(sender: UIButton){
        
    }
    
    private var game: Game = Game()
    
    
    private var OldCell  = UICollectionViewCell()
    private var OldCellTextField = UITextField()
    private var OldCellCordinates = Cordinates(RowIndex: -1, ColIndex: -1)
    
    override func viewWillAppear(_ animated: Bool) {
        game.generateBoard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sudokuCollectionView?.layer.borderWidth = 2
        sudokuCollectionView?.layer.borderColor = UIColor.black.cgColor
        game.startGame()
        
        Timer.scheduledTimer(withTimeInterval: 1.0,
                             repeats: true,
                             block: {_ in
                                let secs = String(format: "%02d",self.game.seconds)
                                let mins = String(format: "%02d",self.game.minutes)
                                let hrs = String(format: "%02d",self.game.hour)
                                self.timerLbl?.text = "Timer: \(hrs): \(mins): \(secs)"
                                })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(OldCellCordinates.RowIndex != -1 && OldCellCordinates.ColIndex != -1){
            
            if(textField.text!.count != 0){
                let itemNumber = game.board?.getIndexFromCordinates(RowIndex: OldCellCordinates.RowIndex, ColIndex: OldCellCordinates.ColIndex)
                
                let returnCode = game.checkIfValid(index: itemNumber!, number: Int(String(textField.text!))!,initialize: false)
                
                if(returnCode == 1){
                    game.getBoard().setNumberAt(RowIndex: OldCellCordinates.RowIndex, ColIndex: OldCellCordinates.ColIndex, number: Int(String(textField.text!))!)
                    
                    OldCell.backgroundColor = .cyan
                    OldCell.layer.borderWidth = 0.5
                    
                    if game.checkIfSolved() {
                        warningLabl?.text = "You win!"
                        game.stopGame()
                    }
                }
                 else if returnCode == -1 {
                    textField.text?.removeAll()
                    game.getBoard().setNumberAt(RowIndex: OldCellCordinates.RowIndex, ColIndex: OldCellCordinates.ColIndex, number: 0)
                    OldCell.backgroundColor = .green
                    OldCell.layer.borderWidth = 0.5
                    warningLabl?.text = "Number exists in row!"
                } else if returnCode == -2 {
                    textField.text?.removeAll()
                    game.getBoard().setNumberAt(RowIndex: OldCellCordinates.RowIndex, ColIndex: OldCellCordinates.ColIndex, number: 0)
                    OldCell.backgroundColor = .green
                    OldCell.layer.borderWidth = 0.5
                    warningLabl?.text = "Number exists in column!"
                } else if returnCode == -3 {
                    textField.text?.removeAll()
                    game.getBoard().setNumberAt(RowIndex: OldCellCordinates.RowIndex, ColIndex: OldCellCordinates.ColIndex, number: 0)
                    OldCell.backgroundColor = .green
                    OldCell.layer.borderWidth = 0.5
                    warningLabl?.text = "Number exists in segment!"
                }
                else if( returnCode == -4){
                    textField.text? = OldCellTextField.text!
                    OldCell.backgroundColor = .cyan
                    OldCell.layer.borderWidth = 0.5
                    warningLabl?.text = "This Number is already at this Location!"
                }
            }
            else{
                OldCell.backgroundColor = .green
                OldCell.layer.borderWidth = 0.5
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
        return string == string.filter("123456789".contains) && textField.text!.count < 1
    }
    
    // define the content of each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // define the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as UICollectionViewCell
        
        // if the cell is on the edge of a segment, thicken its border
//        if indexPath.item % 9 == 3
//        cell.layer.borderWidth = 1.0
        
        // define the label that will display the number on the cell
        let cellTextField = UITextField(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
        cellTextField.textAlignment = .center
        cellTextField.delegate = self
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5
        
        // if cell is a given cell, colour it grey
        if game.isCellGiven(index: indexPath.item) {
            let num = game.getBoard().getNumberAt(index: indexPath.item)
            cellTextField.text = String(num)
            cell.backgroundColor = .lightGray
            cell.isUserInteractionEnabled = false
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
    
}
