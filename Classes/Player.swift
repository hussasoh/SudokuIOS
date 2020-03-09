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

/* I started a high score system, maybe can add it as a bonus when done everything else.

    var highScores: Array<Score> = []   // storage for player's high scores
    let maxScores: Int = 10             // number of high scores to hold
 
    // add score to player's array of scores
    func addScore(_ value: Int, _ gameType: String) {
        // only record top x high scores of scores (x = maxScores constant value)
        if highScores.count > 10 {
            var highestValue: Int = 0
            var replaceIndex: Int = 0
            for i in 0 ..< highScores.count {
                // if player's new score is greater than highest
                if value > highestValue {
                    // set new score as highest
                    highestValue = highScores[i].value
                    // if player's new score is greater than this loop's score,
                    if value > highScores[i].value {
                        replaceIndex = i
                    }
                }
            }
            // now add the score if it was higher than any previous high scores
            if value > highestValue {
                highScores.remove(at: replaceIndex)
                highScores.append(Score.init(value: value,          // the actual new score value
                    gameType: gameType,    // gameType as string (switch to enum?)
                    date: Date.init()))    // current date & time
            }
        }
    }
}

// optional score class to provide a date and gameType for each recorded score
class Score {
    var value: Int!         // the number value of the score
    var gameType: String!   // the Sudoku type
    var date: Date!         // the date when the score was recorded
    
    init(value: Int, gameType: String, date: Date) {
        self.value = value
        self.gameType = gameType
        self.date = date
    }
}
 
*/
