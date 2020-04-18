//
//  Player.swift
//  SudokuIOS
//
//  Created by Terry Nippard on 2020-03-04.
//  Copyright © 2020 Terry Nippard. All rights reserved.
//

import Foundation

class Player: NSObject {
    // player variables
    private var id : Int?                      // player's id
    private var name: String!                  // player's name
    private var score : Int?                   // player's score
    private var savedSPGame: Game?             // state of unfinished singleplayer game
    
    // initializers
    override init() {
        super.init()
    }
    init(name: String) {
        self.name = name
    }
    func initWithData(theRow r : Int, theName n : String, theScore s : Int) {
        id = r
        name = n
        score = s
    }
    
    // getters and setters
    func getId() -> Int {
        return self.id!
    }
    func getName() -> String {
        return self.name!
    }
    func setName(name: String) {
        self.name = name
    }
    func setScore(score: Int) {
        self.score = score
    }
    func getScore() -> Int {
        return self.score!
    }
    
    func getSavedSPGame() -> Game? {
        return self.savedSPGame
    }
    func setSavedSPGame(spGame: Game) {
        self.savedSPGame = spGame
    }
}
