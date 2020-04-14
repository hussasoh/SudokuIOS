//
//  Game.swift
//  SudokuIOS
//
//  Created by Sohaib Hussain on 2020-03-03.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import Foundation

class Game{
    
    var userInfo: Player
    var Board : Board
    var startgame: Bool = false
    
    
    init(userInfo: Player,Board: Board) {
        self.userInfo = userInfo
        self.Board = Board
    }
    
    func StartGame(){
        startgame = true
    }
    
    func SaveGameStatus(){
        //saves games status
    }
    
    func displayBoard(){
        
    }
        
}
