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
    
<<<<<<< HEAD
    var userInfo: Player
=======
    var PlayetInfo: Player
>>>>>>> 38542fd1b4c3188b5d567d01c8e9a82796b802d1
    var Board : Board
    var startgame: Bool = false
    
    
<<<<<<< HEAD
    init(userInfo: Player,Board: Board) {
        self.userInfo = userInfo
=======
    init(PlayetInfo: Player,Board: Board) {
        self.PlayetInfo = PlayetInfo
>>>>>>> 38542fd1b4c3188b5d567d01c8e9a82796b802d1
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
