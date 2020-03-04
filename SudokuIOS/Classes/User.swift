//
//  User.swift
//  SudokuIOS
//
//  Created by Xcode User on 2020-03-03.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import Foundation

class User{
    
    private var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func getName() -> String{
        return self.name
    }
}
