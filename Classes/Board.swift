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
    
    func getBoardArray() -> [[Int]] {
        return self.BoardArray
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
        
        self.BoardArray = boardarray
        
        return boardarray
    }
    
    func setBoardArray(boardArray: [[Int]]) {
        self.BoardArray = boardArray
    }
    
    func getBoardSegments() -> [[BoardSegment]]{
        return boardSegments
    }
    
    func setBoardSegments(segments: [[BoardSegment]]) {
        self.boardSegments = segments
    }
    
    func getNumberAt(RowIndex: Int, ColIndex: Int)-> Int{
        return self.BoardArray[RowIndex][ColIndex]
    }

    // overload to get number at single index
    func getNumberAt(index: Int) -> Int{
        let coords = getCordinatesFromIndex(Index: index)
        return self.BoardArray[coords.RowIndex][coords.ColIndex]
    }
    
    func setNumberAt(RowIndex: Int, ColIndex: Int, number: Int){
        self.BoardArray[RowIndex][ColIndex] = number
    }
    // overload to set number at single index
    func setNumberAt(index: Int, number: Int){
        let coords = getCordinatesFromIndex(Index: index)
        self.BoardArray[coords.RowIndex][coords.ColIndex] = number
    }
    
    func getSegmentFromIndex(index: Int) -> Int {
        let col = index % NUMBER_OF_SEGMENTS_IN_ONE_BOARD
        let row = index / NUMBER_OF_SEGMENTS_IN_ONE_BOARD
        if row < 3 {
            return 0 + col / 3
        }
        else if row < 6 {
            return 1 + col / 3
        }
        else if row < 9 {
            return 2 + col / 3
        }
        
        return -1
    }
    
    func getIndexFromCordinates(RowIndex: Int,ColIndex: Int) -> Int{
        return (NUMBER_OF_SEGMENTS_IN_ONE_BOARD * RowIndex) + ColIndex
    }
    
    func getCordinatesFromIndex(Index: Int) -> Cordinates{
        
        var cordinates : Cordinates
        var Col: Int
        var Row: Int
        
        Col = Index % NUMBER_OF_SEGMENTS_IN_ONE_BOARD
        
        Row = (Index-Col)/NUMBER_OF_SEGMENTS_IN_ONE_BOARD
        cordinates = Cordinates(RowIndex: Row, ColIndex: Col)
        
        return cordinates
    }
    
}

class Cordinates{
    
    var RowIndex: Int
    var ColIndex: Int
    
    init(RowIndex: Int, ColIndex: Int){
        self.RowIndex = RowIndex
        self.ColIndex = ColIndex
    }
}
