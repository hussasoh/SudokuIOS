//
//  Game.swift
//  SudokuIOS
//
//  Created by Sohaib Hussain on 2020-03-03.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import Foundation

class Game{
    
    var userInfo: User
    var board : Board
    var solved: Bool = false    // flag true if game is finished or false if still in progress
    var startgame: Bool = false
    
    init(userInfo: User, board: Board) {
        self.userInfo = userInfo
        self.board = board
    }
    
    func startGame() {
        
        startgame = true
    }
    
    func resumeGame() {
        
    }
    
    func SaveGameStatus(){
        //saves games status
    }
    
    func displayBoard(){
        
    }
}
