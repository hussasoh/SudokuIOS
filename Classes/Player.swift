//
//  Player.swift
//  FinalProject
//
//  Created by Terry Nippard on 2020-03-04.
//  Copyright © 2020 Terry Nippard. All rights reserved.
//

import Foundation

class Player {
    // player variables
    private var name: String!                  // player's name
    private var savedSPGame: Game?             // state of unfinished singleplayer game
    private var savedMPGame: MultiplayerGame?  // state of unfinished multiplayer game
    // maybe store more info here like profile pic or other game center data?
    
    // initializer
    init(name: String) {
        self.name = name
    }
    
    // getters and setters
    func getName() -> String {
        return self.name
    }
    func setName(name: String) {
        self.name = name
    }
    
    func getSavedSPGame() -> Game {
        return self.savedSPGame!
    }
    func setSavedSPGame(spGame: Game) {
        self.savedSPGame = spGame
    }
    
    func getSavedMPGame() -> Game {
        return self.savedMPGame!
    }
    func setSavedMPGame(mpGame: MultiplayerGame) {
        self.savedMPGame = mpGame
    }
}

 
