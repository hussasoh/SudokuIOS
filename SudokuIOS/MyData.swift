//
//  MyData.swift
//  SudokuIOS
//
//  Created by Tomislav Busic on 2020-04-11.
//  Copyright :copyright: 2020 Tomislav Buisc. All rights reserved.
//
import UIKit

class MyData: NSObject {
    
    var id : Int?
    var name : String?
    var score : Int?
    
    func initWithData(theRow r : Int, theName n : String, theScore s : Int) {
        id = r
        name = n
        score = s
    }
    
}