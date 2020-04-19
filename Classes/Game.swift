//
//  Game.swift
//  SudokuIOS
//
//  Created by Terry Nippard on 2020-03-03.
//  Copyright © 2020 Xcode User. All rights reserved.
//

class Game {
    
    var player: Player?         // player who is playing the game
    var board : Board?          // board representing the puzzle grid
    var started: Bool = false   // flag true if game has started, false if not
    var solved: Bool = false    // flag true if game is finished or false if still in progress
    var givenCells = [(Int)]()  // array of all cells provided at beginning of game
    
    // initializers
    init(player: Player, board: Board) {
        self.player = player
        self.board = board
    }
    init() {
        
    }
    
    // getters and setters
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
        
        // also add the 2D array to the board
        getBoard().setBoardArray(boardArray: boardArray)
    }
    
    // test if there is an error on the board with given index, return a value depending
    func checkIfValid(index: Int, number: Int) -> Int {
        // get the coordinates of the param index
        let coords = getBoard().getCordinatesFromIndex(Index: index)
        
        // test whether the number entered is already at given index
        if(board?.getNumberAt(RowIndex: coords.RowIndex, ColIndex: coords.ColIndex) == number){
            // duplicate value detected in same cell as index
            return -4
        }
        
        // test for duplicates in all columns on same row as index
        for col in 0 ..< 9 {
            if board?.getNumberAt(RowIndex: coords.RowIndex, ColIndex: col) == number {
                // duplicate value detected in same row as index
                return -1
            }
        }
        // test for duplicates in all rows on same column as index
        for row in 0 ..< 9 {
            if board?.getNumberAt(RowIndex: row, ColIndex: coords.ColIndex) == number {
                // duplicate value detected in same column as index
                return -2
            }
        }
        
        // test for duplicates in all cells of the same segment as index
        var startRow: Int = 0
        var startCol: Int = 0
        if coords.RowIndex < 3 {
            startRow = 0
        } else if coords.RowIndex < 6 {
            startRow = 3
        } else if coords.RowIndex < 9 {
            startRow = 6
        }
        if coords.ColIndex < 3 {
            startCol = 0
        } else if coords.ColIndex < 6 {
            startCol = 3
        } else if coords.ColIndex < 9 {
            startCol = 6
        }
        for row in startRow ..< startRow + 3 {
            for col in startCol ..< startCol + 3 {
                if getBoard().getNumberAt(RowIndex: row, ColIndex: col) == number {
                    // duplicate detected in same segment as cell at index
                    return -3
                }
            }
        }
        
        // return success value
        return 1
    }
    
    // test row by row to determine whether puzzle has been solved
    func checkIfSolved() -> Bool {
        // define constants
        let rowLength = 9
        let colLength = 9
        
        // for every row in grid,
        for row in 0 ..< rowLength {
            // test that each number appears once
            for testNum in 1 ..< rowLength {
                var found: Bool = false
                for col in 0 ..< colLength {
                    // if the testNum is found, test next num
                    if getBoard().getNumberAt(RowIndex: row, ColIndex: col) == testNum {
                        found = true
                        break
                    }
                    // if a 0 is found, puzzle is not solved
                    if getBoard().getNumberAt(RowIndex: row, ColIndex: col) == 0 {
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
    
    // return true if cell at index was given at the start of game
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
}
