//
<<<<<<< HEAD
//  Player.swift
//  SudokuIOS
//
//  Created by Xcode User on 2020-03-19.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import Foundation
import GameKit

class Player {
    
    private var PlayerName : String?
    
    init(PlayerName: String) {
        self.PlayerName = PlayerName
    }
    
    func AccessGameCenter(){
        
    }
    
    
=======
//  User.swift
//  SudokuIOS
//
//  Created by Sohaib Hussain on 2020-03-03.
//  Copyright © 2020 Xcode User. All rights reserved.
//  User Game Center to retrieve User Information
//

import Foundation

class Player{
    
    private var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func getName() -> String{
        return self.name
    }
>>>>>>> 38542fd1b4c3188b5d567d01c8e9a82796b802d1
}
