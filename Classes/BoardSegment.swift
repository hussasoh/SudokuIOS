//
//  BoardSegment.swift
//  SudokuIOS
//
//  Created by Xcode User on 2020-03-08.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import Foundation

class BoardSegment {
    
    private let NUMBER_OF_ROWS: Int = 3
    private let NUMBER_OF_COLUMNS: Int = 3
    
    private let MIN_NUMBER_ALLOWED_IN_PUZZLE : Int = 1
    private let MAX_NUMBER_ALLOWED_IN_PUZZLE : Int = 9
    
    private let MAX_NUMBERS_IN_SEGMENT: Int = 4
    private let MIN_NUMBERS_IN_SEGMENT: Int = 1
    
    private var numbersInSegment : [[Int]] = [[0,0,0],[0,0,0],[0,0,0]]
    
    //initializes the Board Segment
    //creates random numbers around the segment
    init() {        
        AddRandomNumbersInSegment()
    }
    init(numbers: [[Int]]) {
        self.numbersInSegment = numbers
    }
    
    private func AddRandomNumbersInSegment(){
        let NumbersInSegment = GenerateRandomNumbers(from: MIN_NUMBERS_IN_SEGMENT, to: MAX_NUMBERS_IN_SEGMENT)
        
        for _ in 0...NumbersInSegment {
            
            let numbergen = GenerateRandomNumbers(from: MIN_NUMBER_ALLOWED_IN_PUZZLE, to: MAX_NUMBER_ALLOWED_IN_PUZZLE)
            let ArrayIndexRow = GenerateRandomNumbers(from: 0, to: (NUMBER_OF_ROWS-1))
            let ArrayIndexColumn = GenerateRandomNumbers(from: 0, to: (NUMBER_OF_COLUMNS-1))
            
            for (indexRow,row) in numbersInSegment.enumerated(){
                if(indexRow == ArrayIndexRow){
                    for (indexColumn,_) in row.enumerated(){
                        if(indexColumn == ArrayIndexColumn){
                            numbersInSegment[indexRow].remove(at: indexColumn)
                            numbersInSegment[indexRow].insert(numbergen, at: indexColumn)
                        }
                    }
                }
            }
            
        }
    }
    
    private func GenerateRandomNumbers(from: Int, to: Int) -> Int{
        let randomNumber = Int.random(in: from...to)
        return randomNumber
    }
    
    func getIndex2dArray() -> [[Int]]{
        return numbersInSegment
    }
    
    func getRowFrom2dArray(RowIndex: Int) -> [Int]{
        var array = [Int]()
        
        for (index,row) in numbersInSegment.enumerated(){
            
            if(index == RowIndex){
                for col in row{
                    array.append(col)
                }
            }
        }
        
        return array
    }
    
    
}
