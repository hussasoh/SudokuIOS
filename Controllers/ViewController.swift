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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((SudukoCollectionView?.frame.size.width)!)/9, height: ((SudukoCollectionView?.frame.size.height)!)/9)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (TwoDArray.count * TwoDArray[0].count)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as UICollectionViewCell

        let label = UITextField(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.width))
        label.keyboardType = .numberPad
        label.textAlignment = .center
        label.text = String(indexPath.item)
        label.delegate = self

        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5
        cell.addSubview(label)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cord = board.getCordinatesFromIndex(Index: (indexPath.item + 1))
        labl?.text = "(\(cord.RowIndex),\(cord.ColIndex))"
    }
    
    
}

