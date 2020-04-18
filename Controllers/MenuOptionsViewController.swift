//
//  MenuOptionsViewController.swift
//  SudokuIOS
//
//  Created by Omar Kanawati on 2020-04-17.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit
import AVFoundation

class MenuOptionsViewController: UIViewController {

    @IBOutlet var dark : UISwitch?
    @IBOutlet var musicSlider : UISlider!
    @IBOutlet var musicSwitch : UISwitch!
    @IBOutlet var effectsSlider : UISlider!
    @IBOutlet var effectsSwitch : UISwitch!
    
    // instantiate app delegate object
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dark?.isOn = (mainDelegate.menuOptions.getDarkMode())
        musicSwitch.isOn = (mainDelegate.menuOptions.getMusicOn())
        
        musicSlider.value = mainDelegate.menuOptions.getMusicVolume()
        
        checkDark()
    }
    
    // music will play when options menu has appeared
    override func viewWillAppear(_ animated: Bool) {
    
    }
    
    // toggles music on and off
    @IBAction func toggleMusic(sender: UISwitch) {
        
        if (musicSwitch?.isOn == true) {
            mainDelegate.musicPlayer?.play()
            mainDelegate.menuOptions.setMusicOn(musicOn: true)
        }
        else {
            mainDelegate.musicPlayer?.stop()
            mainDelegate.menuOptions.setMusicOn(musicOn: false)
        }
    }
    
    @IBAction func toggleEffects(sender: UISwitch) {
        
        if (effectsSwitch?.isOn == true) {
            mainDelegate.menuOptions.setEffectsOn(effectsOn: true)
        }
        else {
            mainDelegate.menuOptions.setEffectsOn(effectsOn: false)
        }
    }
    
    // controls the volume of music
    @IBAction func volumeDidChange(sender : UISlider) {
        
        mainDelegate.musicPlayer?.volume = musicSlider.value
        mainDelegate.menuOptions.setMusicVolume(musicVolume: musicSlider.value)
    }
    
    // controls the volume of sound effects
    @IBAction func effectsDidChange(sender : UISlider) {
        
        if (mainDelegate.menuOptions.getEffectsOn() == true) {
            mainDelegate.soundPlayer?.volume = effectsSlider.value
            mainDelegate.menuOptions.setMusicVolume(musicVolume: effectsSlider.value)
            mainDelegate.soundPlayer?.play()
        }       
    }
    
    // toggles "dark mode"
    @IBAction func toggleDarkMode(sender: UISwitch) {
        
        checkDark()
        
    }
    
    func checkDark() {
        if (dark?.isOn == true) {
            view.backgroundColor = .black
        
            mainDelegate.menuOptions.setDarkMode(darkMode: true)
        }
        else {
            view.backgroundColor = .white
            mainDelegate.menuOptions.setDarkMode(darkMode: false)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
