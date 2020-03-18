//
//  Board.swift
//  SudokuIOS
//
//  Created by Sohaib Hussain on 2020-03-03.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import Foundation

class Board{
 
    private let NUMBER_OF_SEGMENTS_IN_ONE_BOARD = 9
    
    private let NUMBER_OF_BOARD_ROWS = 3
    private let NUMBER_OF_BOARD_COLUMNS = 3
    private var boardSegments = [[BoardSegment]]()
    private var BoardArray = [[Int]]()
    
    init(){
        AddSegmentsToBoard()
        BoardArray = getBoard2dArray()
    }
    
    private func AddSegmentsToBoard(){
        for _ in 0 ..< NUMBER_OF_BOARD_ROWS
        {
            var row  =  [BoardSegment]()
            for _ in 0 ..< NUMBER_OF_BOARD_COLUMNS
            {
                row.append(BoardSegment())
            }
            boardSegments.append(row)
        }
    }
    
    func getBoard2dArray() -> [[Int]]{
        var boardarray : [[Int]] = [[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],
             [0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],
             [0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]]
        
        var array = [Int]()
        
        var BoardRowIndex = 0
        
        for BoardRow in boardSegments{
            for segmentRow in 0...2{
                for BoardCol in BoardRow{
                    for num in BoardCol.getRowFrom2dArray(RowIndex: segmentRow){
                        array.append(num)
                    }
                }
                for (elementIndex,element) in array.enumerated(){
                    boardarray[BoardRowIndex][elementIndex] = element
                }
                array.removeAll()
                BoardRowIndex = BoardRowIndex + 1
            }
        }
        
        return boardarray
    }
    
    func getBoardSegments() -> [[BoardSegment]]{
        return boardSegments
    }
    
    func getNumberAt(RowIndex: Int, ColIndex: Int)-> Int{
        return self.BoardArray[RowIndex][ColIndex]
    }
    
}
