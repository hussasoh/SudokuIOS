//
//  Game.swift
//  SudokuIOS
//
//  Created by Terry Nippard on 2020-03-03.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import Foundation
import AVFoundation

class Game {
    
    var player: Player?
    var board : Board?
    var solved: Bool = false    // flag true if game is finished or false if still in progress
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
    
    // test if there is an error on the board with given index
    func checkIfValid(index: Int, number: Int) -> Int {
        // get the coordinates of the param index
        let coords = board?.getCordinatesFromIndex(Index: index)
        if(board?.getNumberAt(RowIndex: coords!.RowIndex, ColIndex: coords!.ColIndex) == number){
            return -4
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
        
        // play the winning sound
        
        return true
    }
    
    func generateBoard() {
        // clear board
        for i in 0..<board!.getBoard2dArray().count {
            board!.setNumberAt(index: i, number: 0)
        }
        // hardcoded puzzle for debugging (we know the solution)
        getBoard().setNumberAt(RowIndex: 0, ColIndex: 2, number: 8)
        getBoard().setNumberAt(RowIndex: 0, ColIndex: 7, number: 2)
        
        getBoard().setNumberAt(RowIndex: 1, ColIndex: 0, number: 1)
        getBoard().setNumberAt(RowIndex: 1, ColIndex: 1, number: 2)
        getBoard().setNumberAt(RowIndex: 1, ColIndex: 4, number: 8)
        getBoard().setNumberAt(RowIndex: 1, ColIndex: 7, number: 9)
        getBoard().setNumberAt(RowIndex: 1, ColIndex: 8, number: 4)
        
        getBoard().setNumberAt(RowIndex: 2, ColIndex: 0, number: 6)
        getBoard().setNumberAt(RowIndex: 2, ColIndex: 3, number: 9)
        getBoard().setNumberAt(RowIndex: 2, ColIndex: 6, number: 8)
        getBoard().setNumberAt(RowIndex: 2, ColIndex: 7, number: 3)
       
        getBoard().setNumberAt(RowIndex: 3, ColIndex: 0, number: 7)
        getBoard().setNumberAt(RowIndex: 3, ColIndex: 3, number: 6)
        getBoard().setNumberAt(RowIndex: 3, ColIndex: 4, number: 3)
        getBoard().setNumberAt(RowIndex: 3, ColIndex: 5, number: 5)
        
        getBoard().setNumberAt(RowIndex: 4, ColIndex: 0, number: 4)
        getBoard().setNumberAt(RowIndex: 4, ColIndex: 2, number: 6)
        getBoard().setNumberAt(RowIndex: 4, ColIndex: 3, number: 2)
        getBoard().setNumberAt(RowIndex: 4, ColIndex: 5, number: 7)
        getBoard().setNumberAt(RowIndex: 4, ColIndex: 6, number: 9)
        getBoard().setNumberAt(RowIndex: 4, ColIndex: 8, number: 3)
        
        getBoard().setNumberAt(RowIndex: 5, ColIndex: 3, number: 8)
        getBoard().setNumberAt(RowIndex: 5, ColIndex: 4, number: 4)
        getBoard().setNumberAt(RowIndex: 5, ColIndex: 5, number: 9)
        getBoard().setNumberAt(RowIndex: 5, ColIndex: 8, number: 6)
        
        getBoard().setNumberAt(RowIndex: 6, ColIndex: 1, number: 4)
        getBoard().setNumberAt(RowIndex: 6, ColIndex: 2, number: 2)
        getBoard().setNumberAt(RowIndex: 6, ColIndex: 5, number: 8)
        getBoard().setNumberAt(RowIndex: 6, ColIndex: 8, number: 9)
        
        getBoard().setNumberAt(RowIndex: 7, ColIndex: 0, number: 9)
        getBoard().setNumberAt(RowIndex: 7, ColIndex: 1, number: 6)
        getBoard().setNumberAt(RowIndex: 7, ColIndex: 4, number: 5)
        getBoard().setNumberAt(RowIndex: 7, ColIndex: 7, number: 8)
        getBoard().setNumberAt(RowIndex: 7, ColIndex: 8, number: 1)
        
        getBoard().setNumberAt(RowIndex: 8, ColIndex: 1, number: 3)
        getBoard().setNumberAt(RowIndex: 8, ColIndex: 6, number: 5)
        
        // for every puzzle number set, mark it in our givenCells array
        for i in 0..<(9 * 9) {
            if (getBoard().getNumberAt(index: i)) > 0 {
                givenCells.append(1)
            } else {
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
