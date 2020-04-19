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

    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var dark : UISwitch?
    @IBOutlet var musicSlider : UISlider!
    @IBOutlet var musicSwitch : UISwitch!
    
    var soundPlayer : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dark?.isOn = false;
    }
    
    // music will play when options menu has appeared
    override func viewWillAppear(_ animated: Bool) {
        
        let soundURL = Bundle.main.path(forResource: "puzzle_music", ofType: "mp3")
        let url = URL(fileURLWithPath: soundURL!)
        soundPlayer = try! AVAudioPlayer.init(contentsOf: url)
        soundPlayer?.currentTime = 0
        soundPlayer?.volume = musicSlider.value
        soundPlayer?.numberOfLoops = -1
        soundPlayer?.play()
        
    }
    
    // toggles music on and off
    @IBAction func toggleMusic(sender: UISwitch) {
        
        if (musicSwitch?.isOn == true) {
            soundPlayer?.play()
        }
        else {
            soundPlayer?.stop()
        }
    }
    
    // controls the volume of music
    @IBAction func volumeDidChange(sender : UISlider) {
        
        soundPlayer?.volume = musicSlider.value
    }
}
