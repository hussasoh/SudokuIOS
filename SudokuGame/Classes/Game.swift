//
//  Game.swift
//  SudokuIOS
//
//  Created by Sohaib Hussain on 2020-03-03.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import Foundation
import UIKit

class Game{
    
    var PlayetInfo: Player
    var Board : Board
    var startgame: Bool = false
    
    
    init(PlayetInfo: Player,Board: Board) {
        self.PlayetInfo = PlayetInfo
        self.Board = Board
    }
    
    func StartGame(){
        startgame = true
    }
    
    func SaveGameStatus(){
        //saves games status
    }
    
    func displayBoard() -> UITableView{
        let view = UITableView()
        
        
        
        return view
    }
        
}
