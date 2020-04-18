//
//  GameOptions.swift
//  SudokuIOS
//
//  Created by Omar Kanawati on 2020-03-07.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import Foundation

struct GameOptions: OptionSet {
    let rawValue: Int
    
    static let easy = GameOptions(rawValue: 1 << 0)
    static let normal = GameOptions(rawValue: 1 << 1)
    static let hard = GameOptions(rawValue: 1 << 2)
    static let background1 = GameOptions(rawValue: 1 << 3)
    static let background2 = GameOptions(rawValue: 1 << 4)
    
    static let all: GameOptions = [.easy, .normal, .hard, .background1, .background2]
}
