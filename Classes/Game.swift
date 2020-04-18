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
        self.player = Player(name: "Sohaib")
        self.board = Board()
        timer = Timer()
        seconds = 0
        minutes = 0
        hour = 0
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
        self.startTimer()
    }
    
    func stopGame() {
        started = false
        self.stopTimer()
    }
    
    func resumeGame() {
        started = true
        self.startTimer()
    }
    
    func saveGameStatus() {
        // saves games status
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
