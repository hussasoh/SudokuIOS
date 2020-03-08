//
//  MultiplayerGame.swift
//  SudokuIOS
//
//  Created by Terry Nippard on 2020-03-05.
//  Copyright © 2020 Terry Nippard. All rights reserved.
//

import Foundation

enum GameType {
    case singlePlayer
    case killer
    case versus
    case coop
}

class MultiplayerGame : Game {
    
    var userInfo2: User                 // the player's competition
    var gameType: GameType
    var yourTurn: Bool                  // tracks if it's the player's turn, or player 2's
    
    init(userInfo: User, user2Info: User, board: Board, gameType: GameType) {
        self.userInfo2 = user2Info
        self.gameType = gameType
        
        // determine who goes first by using random boolean, like a coin flip
        self.yourTurn = Bool.random()
        
        // finish init with the super class
        super.init(userInfo: userInfo, board: board)
    }
    
    override func startGame() {
        super.startGame()   // call parent method if necessary
        
        // if game isn't already solved
        if self.solved == false {
            
            // do different logic depending on the type of game
            if gameType == .coop {
                print("Starting co-op game...")
            }
            else if gameType == .versus {
                print("Starting versus game...")
            }
            
            // if it's your turn,
            if yourTurn {
                // let the player play
            }
            else {
                // warn the player it's the other player's turn
            }
        }
    }
    
    override func resumeGame() {
        
    }
    
    func getGameType() -> GameType {
        return gameType
    }
}
