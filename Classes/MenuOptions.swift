//
//  MenuOptions.swift
//  SudokuIOS
//
//  Created by Omar Kanawati on 2020-03-07.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import Foundation

class MenuOptions {
    
    private var musicOn : Bool
    private var musicVolume : Int
    private var effectsOn : Bool
    private var effectsVolume : Int
    private var darkMode : Bool
    
    init(musicOn : Bool, musicVolume : Int, effectsOn : Bool, effectsVolume : Int, darkMode : Bool) {
        self.musicOn = musicOn
        self.musicVolume = musicVolume
        self.effectsOn = effectsOn
        self.effectsVolume = effectsVolume
        self.darkMode = darkMode
    }
    
    func getMusicOn() -> Bool {
        return self.musicOn
    }
    
    func setMusicOn(musicOn : Bool) {
        self.musicOn = musicOn
    }
    
    func getMusicVolume() -> Int {
        return self.musicVolume
    }
    
    func setMusicVolume(musicVolume : Int) {
        self.musicVolume = musicVolume
    }
    
    func getEffectsOn() -> Bool {
        return self.effectsOn
    }
    
    func setEffectsOn(effectsOn : Bool) {
        self.effectsOn = effectsOn
    }
    
    func getEffectsVolume() -> Int {
        return self.effectsVolume
    }
    
    func setEffectsVolume(effectsVolume : Int) {
        self.effectsVolume = effectsVolume
    }
    
    func getDarkMode() -> Bool {
        return self.darkMode
    }
    
    func setDarkMode(darkMode : Bool) {
        self.darkMode = darkMode
    }
    
    
}
