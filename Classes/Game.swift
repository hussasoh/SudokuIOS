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
    var solved: Bool = false    // flag true if game is finished or false if still in progress
    var started: Bool = false
    var givenCells = [(Int)]()
    
    init(player: Player, board: Board) {
        self.player = player
        self.board = board
    }
    init() {
        
    }
    
    func getBoard() -> Board {
        return board!
    }
    func getPlayer() -> Player {
        return player!
    }
    func setBoard(board: Board) {
        self.board = board
    }
    func setPlayer(player: Player) {
        self.player = player
    }
    
    func startGame() {

        started = true
    }
    
    func stopGame() {
        
    }
    
    func resumeGame() {
        
    }
    
    func saveGameStatus() {
        // saves games status
    }
    
    // test if there is an error on the board with given index
    func checkIfValid(index: Int, number: Int) -> Int {
        // get the coordinates of the param index
        let coords = board?.getCordinatesFromIndex(Index: index)
        // test for duplicates in all columns on same row
        if(board?.getNumberAt(RowIndex: coords!.RowIndex, ColIndex: coords!.ColIndex) == number){
            return -4
        }
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
        // see if ints round up or down or what
        let printInt = Int(5 / 2)
        print("5 / 2 = \(printInt)")
        
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
    
    func generateBoard() {
        // clear board
        for i in 0..<board!.getBoard2dArray().count {
            board!.setNumberAt(index: i, number: 0)
        }
        // hardcoded puzzle for debugging (we know the solution)
        board!.setNumberAt(RowIndex: 0, ColIndex: 2, number: 8)
        board!.setNumberAt(RowIndex: 0, ColIndex: 7, number: 2)
        
        board!.setNumberAt(RowIndex: 1, ColIndex: 0, number: 1)
        board!.setNumberAt(RowIndex: 1, ColIndex: 1, number: 2)
        board!.setNumberAt(RowIndex: 1, ColIndex: 4, number: 8)
        board!.setNumberAt(RowIndex: 1, ColIndex: 7, number: 9)
        board!.setNumberAt(RowIndex: 1, ColIndex: 8, number: 4)
        
        board!.setNumberAt(RowIndex: 2, ColIndex: 0, number: 6)
        board!.setNumberAt(RowIndex: 2, ColIndex: 3, number: 9)
        board!.setNumberAt(RowIndex: 2, ColIndex: 6, number: 8)
        board!.setNumberAt(RowIndex: 2, ColIndex: 7, number: 3)
       
        board!.setNumberAt(RowIndex: 3, ColIndex: 0, number: 7)
        board!.setNumberAt(RowIndex: 3, ColIndex: 3, number: 6)
        board!.setNumberAt(RowIndex: 3, ColIndex: 4, number: 3)
        board!.setNumberAt(RowIndex: 3, ColIndex: 5, number: 5)
        
        board!.setNumberAt(RowIndex: 4, ColIndex: 0, number: 4)
        board!.setNumberAt(RowIndex: 4, ColIndex: 2, number: 6)
        board!.setNumberAt(RowIndex: 4, ColIndex: 3, number: 2)
        board!.setNumberAt(RowIndex: 4, ColIndex: 5, number: 7)
        board!.setNumberAt(RowIndex: 4, ColIndex: 6, number: 9)
        board!.setNumberAt(RowIndex: 4, ColIndex: 8, number: 3)
        
        board!.setNumberAt(RowIndex: 5, ColIndex: 3, number: 8)
        board!.setNumberAt(RowIndex: 5, ColIndex: 4, number: 4)
        board!.setNumberAt(RowIndex: 5, ColIndex: 5, number: 9)
        board!.setNumberAt(RowIndex: 5, ColIndex: 8, number: 6)
        
        board!.setNumberAt(RowIndex: 6, ColIndex: 1, number: 4)
        board!.setNumberAt(RowIndex: 6, ColIndex: 2, number: 2)
        board!.setNumberAt(RowIndex: 6, ColIndex: 5, number: 8)
        board!.setNumberAt(RowIndex: 6, ColIndex: 8, number: 9)
        
        board!.setNumberAt(RowIndex: 7, ColIndex: 0, number: 9)
        board!.setNumberAt(RowIndex: 7, ColIndex: 1, number: 6)
        board!.setNumberAt(RowIndex: 7, ColIndex: 4, number: 5)
        board!.setNumberAt(RowIndex: 7, ColIndex: 7, number: 8)
        board!.setNumberAt(RowIndex: 7, ColIndex: 8, number: 1)
        
        board!.setNumberAt(RowIndex: 8, ColIndex: 1, number: 3)
        board!.setNumberAt(RowIndex: 8, ColIndex: 6, number: 5)
        
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
}
