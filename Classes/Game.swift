//
//  Game.swift
//  SudokuIOS
//
//  Created by Terry Nippard on 2020-03-03.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import Foundation

class Game {
    
    var player: Player?
    var board : Board? 
    var solved: Bool = false  // flag true if game is finished or false if still in progress
    private var started: Bool = false
    private var givenCells = [(Int)]()
    
    private var timer: Timer
    private var isTimerOn : Bool = false
    
    var seconds: Int
    var minutes: Int
    var hour : Int
    
    init(player: Player, board: Board) {
        self.player = player
        self.board = board
        timer = Timer()
        seconds = 0
        minutes = 0
        hour = 0
    }
    
    //testing purposes
    init(){
        timer = Timer()
        seconds = 0
        minutes = 0
        hour = 0
    }
    
    func getPlayer() -> Player {
        return player!
    }
    func setPlayer(player: Player) {
        self.player = player
    }
    func getBoard() -> Board {
        return board!
    }
    func setBoard(board: Board) {
        self.board = board
    }
    func isStarted() -> Bool {
        return self.started
    }
    func setStarted(isStarted: Bool) {
        self.started = isStarted
        if(isStarted){
            self.startTimer()
        }
        else{
            self.stopTimer()
        }
    }
    func isSolved() -> Bool {
        return self.solved
    }
    func setSolved(isSolved: Bool) {
        self.solved = isSolved
    }
    func getGivenCells() -> [Int] {
        return self.givenCells
    }
    func setGivenCells(givenCells: [Int]) {
        self.givenCells = givenCells
    }
    
    
    // test if there is an error on the board with given index
    func checkIfValid(index: Int, number: Int, initialize: Bool) -> Int {
        // get the coordinates of the param index
        let coords = board?.getCordinatesFromIndex(Index: index)
        
        if !initialize {
            if(board?.getNumberAt(RowIndex: coords!.RowIndex, ColIndex: coords!.ColIndex) == number){
                return -4
            }
        }
        // test for duplicates in all columns on same row
        for col in 0..<9 {
            if board?.getNumberAt(RowIndex: coords!.RowIndex, ColIndex: col) == number {
                print("Dup found: (\(String(describing: coords!.RowIndex)), \(String(describing: coords!.ColIndex))) vs. (\(String(describing: coords!.RowIndex)), \(col))")
                return -1
            }
        }
        // test for duplicates in all rows on same column
        for row in 0..<9 {
            if board?.getNumberAt(RowIndex: row, ColIndex: coords!.ColIndex) == number {
                print("Dup found: (\(String(describing: coords!.RowIndex)), \(String(describing: coords!.ColIndex))) vs. (\(String(describing: row)), \(coords!.ColIndex))")
                return -2
            }
        }
        
        // for current segment in grid,
        var startRow: Int = 0
        var startCol: Int = 0
        if coords!.RowIndex < 3 {
            startRow = 0
        } else if coords!.RowIndex < 6 {
            startRow = 3
        } else if coords!.RowIndex < 9 {
            startRow = 6
        }
        if coords!.ColIndex < 3 {
            startCol = 0
        } else if coords!.ColIndex < 6 {
            startCol = 3
        } else if coords!.ColIndex < 9 {
            startCol = 6
        }
        for row in startRow..<startRow + 3 {
            for col in startCol..<startCol + 3 {
                if board?.getNumberAt(RowIndex: row, ColIndex: col) == number {
                    print("Dup of \(number) found: (\(row), \(col))")
                    return -3
                }
            }
        }
        
        return 1
    }
    
    // test row by row, col by col, and by segment to see if puzzle has been solved
    func checkIfSolved() -> Bool {
        // define constants
        let rowLength = 9
        let colLength = 9
        
        // for every row in grid,
        for row in 0..<rowLength {
            // test that each number appears once
            for testNum in 1..<rowLength {
                var found: Bool = false
                for col in 0..<colLength {
                    // if the testNum is found, test next num
                    if board?.getNumberAt(RowIndex: row, ColIndex: col) == testNum {
                        found = true
                        break
                    }
                    // if a 0 is found, puzzle is not solved
                    if board?.getNumberAt(RowIndex: row, ColIndex: col) == 0 {
                        print("Zero found: (\(row), \(col))")
                        return false
                    }
                }
                // if testNum was not found on this row, puzzle is not solved
                if !found {
                    return false
                }
            }
        }
        
        // if haven't returned false by now, puzzle has been solved
        solved = true
        return true
    }
    
    //generates the initialized board
    func generateBoard() {
        // make sure the board setup includes one number in its row and column
        for Row in 0 ..< 9{
            for col in 0..<9{
                let index = board?.getIndexFromCordinates(RowIndex: Row, ColIndex: col)
                let num = board?.getNumberAt(index: index!)
                
                if(num != 0){
                    let returncode = self.checkIfValid(index: index!, number: num!,initialize: true)
                    
                    if(returncode == -1){
                        //same number in row
                        for possibleNumber in 0..<9{
                            let isrightNumber = self.checkIfValid(index: index!, number: possibleNumber,initialize: true)
                            if(isrightNumber == 1){
                                board?.setNumberAt(index: index!, number: possibleNumber)
                                break
                            }
                        }
                    }
                    
                    if(returncode == -2){
                        //same number in column
                        for possibleNumber in 0..<9{
                            let isrightNumber = self.checkIfValid(index: index!, number: possibleNumber,initialize: true)
                            if(isrightNumber == 1){
                                board?.setNumberAt(index: index!, number: possibleNumber)
                            }
                        }
                    }
                }
                
                
            }
            
        }
        // for every puzzle number set, mark it in our givenCells array
        for i in 0..<(9 * 9) {
            if (board?.getNumberAt(index: i))! > 0 {
                givenCells.append(1)
            } else {
                givenCells.append(0)
            }
        }
    }
    
    func isCellGiven(index: Int) -> Bool {
        if givenCells[index] == 1 {
            return true
        } else {
            return false
        }
    }
    
    // return true if cell at index has a user-entered value
    func isUserCell(index: Int) -> Bool {
        if !isCellGiven(index: index) && getBoard().getNumberAt(index: index) > 0 {
            return true
        } else {
            return false
        }
    }
    
    // returns a board created with a given 2D array
    func createBoardFrom2dArray(boardArray: [[Int]]) {
        // create a 3x3 grid of BoardSegments
        var boardSegments = [[BoardSegment]]()
        
        // for each row of segments on the board
        for boardSegRow in 0 ..< 3 {
            // define the row of board segments
            var boardSegmentRow = [BoardSegment]()
            // for each column of segments on the board
            for boardSegCol in 0 ..< 3 {
                // define the array of rows in the current segment
                var segRows = [[Int]]()
                // for each row in the segment
                for segRow in 0 ..< 3 {
                    // define the array of values for the row
                    var rowNums = [Int]()
                    // for each column in the segment
                    for segCol in 0 ..< 3 {
                        // get the cell value at this position of the boardArray
                        let cellValue = boardArray[segRow + boardSegRow * 3][segCol + boardSegCol * 3]
                        // add the cell value to the current row
                        rowNums.append(cellValue)
                    }
                    // add the 3 rows of cells we just got to the array of segment rows
                    segRows.append(rowNums)
                }
                // add the three segments we just created to array of board segment rows
                boardSegmentRow.append(BoardSegment(numbers: segRows))
            }
            // add the three arrays of board segment rows to the 3x3 boardSegments grid
            boardSegments.append(boardSegmentRow)
        }
        
        // create the board with the 3x3 grid of BoardSegments
        let board = Board()
        board.setBoardSegments(segments: boardSegments)
        
        // assign the board to this game
        self.board = board
        
        // record the given cells of the board
        recordGivenCells()
    }

    // record all entered cell values of current board as given cells
    // note: only works with new boards that are free of user input
    func recordGivenCells() {
        for i in 0 ..< 9 * 9 {
            if getBoard().getNumberAt(index: i) > 0 {
                givenCells.append(1)
            }
            else {
                givenCells.append(0)
            }
        }
    }
    
    private func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Game.updateTimer), userInfo: nil, repeats: true)
    }
    
    //function for incrememting time
    @objc func updateTimer(){
        seconds += 1
        
        if(seconds == 60){
            seconds = 0
            minutes += 1
        }
        
        if(minutes == 60){
            minutes = 0
            hour += 1
        }
    }
    
    //stopping the timer
    private func stopTimer(){
        isTimerOn = false
        timer.invalidate()
    }
}
