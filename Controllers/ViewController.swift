//
//  ViewController.swift
//  SudokuIOS
//
//  Created by Xcode User on 2020-03-03.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate{

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
        
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        return string == string.filter("0123456789".contains) && textField.text!.count < 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((SudukoCollectionView?.frame.size.width)!)/9, height: ((SudukoCollectionView?.frame.size.height)!)/9)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (TwoDArray.count * TwoDArray[0].count)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as UICollectionViewCell

        let label = UITextField(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width , height: cell.frame.size.height))
        label.keyboardType = .numberPad
        label.textAlignment = .center
        label.delegate = self
        label.tag = 2

        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5
        cell.addSubview(label)
        cell.sendSubviewToBack(label)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cord = board.getCordinatesFromIndex(Index: (indexPath.item))
        labl?.text = "(\(cord.RowIndex),\(cord.ColIndex))"
        
        
        let cell = collectionView.cellForItem(at: indexPath)
        let texfield = cell?.viewWithTag(2) as! UITextField
        
        cell?.bringSubviewToFront(texfield)
        
    }
    
    
}

