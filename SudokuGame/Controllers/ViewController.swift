//
//  ViewController.swift
//  SudokuIOS
//
//  Created by Xcode User on 2020-03-03.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate{

    //didSelect on Cell in Sudoku
    var OldCell = UICollectionViewCell()
    var OldCellTextField = UITextField()
    var OldCellCordinates = Cordinates(RowIndex: -1, ColIndex: -1)
    
    
    private let board = Board()
    private var TwoDArray : [[Int]] = [[]]
    private var Size = CGSize()
    
    @IBOutlet var labl : UILabel?
    
    @IBOutlet var SudukoCollectionView : UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TwoDArray = board.getBoard2dArray()

        Size = (SudukoCollectionView?.frame.size)!
        
        SudukoCollectionView?.layer.borderWidth = 3
        SudukoCollectionView?.layer.borderColor = UIColor.black.cgColor
        
        print(TwoDArray.count * TwoDArray[0].count)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(OldCellCordinates.RowIndex != -1 && OldCellCordinates.ColIndex != -1){
            TwoDArray[OldCellCordinates.RowIndex][OldCellCordinates.ColIndex] = Int(String(textField.text!))!
        }
        return textField.resignFirstResponder()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((SudukoCollectionView?.frame.size.width)!)/9, height: ((SudukoCollectionView?.frame.size.height)!)/9)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (TwoDArray.count * TwoDArray[0].count)
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

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cord = board.getCordinatesFromIndex(Index: (indexPath.item))
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as UICollectionViewCell

        let label = UITextField(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.width))
        label.keyboardType = .numberPad
        label.textAlignment = .center
        label.tag = indexPath.item + 5
        label.text = String(TwoDArray[cord.RowIndex][cord.ColIndex])
        label.isEnabled = false
        label.delegate = self

        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5
        cell.addSubview(label)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        OldCell.layer.borderWidth = 0.5
        OldCell.layer.borderColor = UIColor.black.cgColor
        var _ = textFieldShouldReturn(OldCellTextField)
        OldCellTextField.isEnabled = false
        
        let cord = board.getCordinatesFromIndex(Index: (indexPath.item))
        
        let cell = collectionView.cellForItem(at: indexPath)
        let textfield = cell?.viewWithTag(indexPath.item + 5) as! UITextField
        
        textfield.isEnabled = true
        cell?.layer.borderWidth = 3
        cell?.layer.borderColor = UIColor.red.cgColor
        textfield.becomeFirstResponder()
        
        
        OldCell = cell ?? UICollectionViewCell()
        OldCellTextField = textfield
        OldCellCordinates = cord

        labl?.text = "(\(cord.RowIndex),\(cord.ColIndex)): Value \(TwoDArray[cord.RowIndex][cord.ColIndex])"
    }
    
    
}

