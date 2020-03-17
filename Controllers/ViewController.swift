//
//  ViewController.swift
//  SudokuIOS
//
//  Created by Xcode User on 2020-03-03.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var textView: UITextView?
    
    @IBOutlet var getnumLabel: UILabel?
    @IBOutlet var getRowCord: UITextField?
    @IBOutlet var getColCord: UITextField?
    
    private let board = Board()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let boardsegments = board.getBoard2dArray()
        var fularr: String = ""
        
//        for row in boardsegments{
//            for column in row{
//                fularr.append("[")
//                for rowinsegment in column.getIndex2dArray(){
//                    for colinsegment in rowinsegment{
//                        fularr.append(String(colinsegment) + ",")
//                    }
//                }
//                fularr.append("],")
//            }
//        }
        
        for row in boardsegments{
            fularr.append("[")
            for column in row{
                fularr.append(String(column))
            }
            fularr.append("]\n")
        }
        
        textView?.text = fularr 
        // Do any additional setup after loading the view.
    }
    
    @IBAction func getNumberAt(sender: UIButton){
        let row  = getRowCord?.text
        let col  = getColCord?.text
        
        let rowCord = Int(row!)
        let colCord = Int(col!)
        
        if(rowCord! <= 9 && colCord! <= 9 && rowCord! >= 1 && colCord! >= 1){
            getnumLabel?.text = String(board.getNumberAt(RowIndex: (rowCord!-1), ColIndex: (colCord!-1)))
        }
    }


}

