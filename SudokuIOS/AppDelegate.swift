//
//  AppDelegate.swift
//  SudokuIOS
//
//  Created by Tomislav Busic on 2020-03-03.
//  Copyright © 2020 Tomislav Busic. All rights reserved.
//

// Author: Tomislav Busic.
// Note: We have authors for individual methods in our app delegate. Noted below in comments.

import UIKit
import FacebookCore
import Foundation
import SQLite3
import Firebase
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?                               // reference to the window
    var databaseName : String? = "ProjectDatabase.db"   // DB file name
    var databasePath : String?                          // DB path
    let defaults = UserDefaults.standard                // access the UserDefaults storage
    
    // menu and game options instances for global access
    var gameOptions : GameOptions = [.easy, .background1]
    var menuOptions = MenuOptions(musicOn: true, musicVolume: 5, effectsOn: true, effectsVolume: 10, darkMode: false)
    
    // array that contains different game mode icons and background choices
    var imgData = ["sudoku_easy.png", "sudoku_normal.png", "sudoku_hard.png", "watercolor.jpg", "clouds.jpg"]
    
    // array of scores and their winners' names
    var players : [Player] = []
    
    // the player that started the most recent game
    var currentPlayer : Player? = nil
    
    // audio players for music and sound effects
    var musicPlayer : AVAudioPlayer?        // audio player for the puzzle music
    var soundPlayer : AVAudioPlayer?        // audio player for the SFX
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // basic configuration of FireBase
        FirebaseApp.configure()
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir = documentPaths[0]
        databasePath = documentsDir.appending("/" + databaseName!)
        checkAndCreateDatabase()
        readDataFromDatabase()
        setMusicAndEffects()    // play the music globally
        return true
    }
    
    // Author: Terry Nippard
    // save the game progress to userDefaults
    func saveProgress(game: Game) {
        // save the player name
        defaults.set(game.getPlayer().getName(), forKey: "playerName")
        
        // save the board array
        defaults.set(game.getBoard().getBoardArray(), forKey: "boardArray")
        
        // save the given cells of the board
        defaults.set(game.getGivenCells(), forKey: "givenCells")
        
        //sets timer information
        defaults.set(game.seconds, forKey: "seconds")
        defaults.set(game.minutes, forKey: "minutes")
        defaults.set(game.hour, forKey: "hour")
        
        // synchronize the userDefaults
        defaults.synchronize()
    }
    
    // Author: Terry Nippard
    // load the game progress from userDefaults if exists
    func loadProgress() -> Game {
        // create a game object to hold userDefaults game progress
        let game = Game()
        
        // retrieve player data from userDefaults and create a player with it if exists
        if defaults.string(forKey: "playerName") != nil {
            let savedPlayer = Player()
            let playerName = defaults.string(forKey: "playerName")
            savedPlayer.setName(name: playerName!)
            
            // set the game's player to the retrieved player
            game.setPlayer(player: savedPlayer)
        }
        else {
            print("No player name saved in UserDefaults.")
        }
        
        // retrieve the board array from userDefaults if it exists
        if defaults.array(forKey: "boardArray") != nil {
            let boardArray = defaults.array(forKey: "boardArray") as? [[Int]]
            // create a 3x3 grid of row segments using the retrieved array
            game.createBoardFrom2dArray(boardArray: boardArray!)
        }
        else {
            print("No board saved in UserDefaults.")
        }
        
        // get the given cells array from userDefaults
        if defaults.array(forKey: "givenCells") != nil {
            let givenCells = defaults.array(forKey: "givenCells") as? [Int]
            game.setGivenCells(givenCells: givenCells!)
        }
        else {
            print("No given cells saved in UserDefaults.")
        }
        
        if defaults.integer(forKey: "seconds") != 0 {
            let seconds = defaults.integer(forKey: "seconds") as Int
            game.seconds = seconds
        }
        
        if defaults.integer(forKey: "minutes") != 0 {
            let minutes = defaults.integer(forKey: "minutes") as Int
            game.minutes = minutes
        }
        
        if defaults.integer(forKey: "hour") != 0 {
            let hour = defaults.integer(forKey: "hour") as Int
            game.hour = hour
        }
        
        return game
    }
    
    // Author: Terry Nippard
    // delete the game progress data from userDefaults
    func deleteProgress() {
        defaults.removeObject(forKey: "playerName")
        defaults.removeObject(forKey: "boardArray")
        defaults.removeObject(forKey: "givenCells")
        defaults.removeObject(forKey: "seconds")
        defaults.removeObject(forKey: "minutes")
        defaults.removeObject(forKey: "hour")
        // synchronize the changes with userDefaults
        defaults.synchronize()
    }
    
    //Importing Facebook (Tomislav Busic)
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return ApplicationDelegate.shared.application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation
        )
    }
    
    // Author: Tomislav Busic
    //Importing Facebook (Tomislav Busic)
    @available(iOS 9.0, *)
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return ApplicationDelegate.shared.application(application, open: url, options: options)
    }
    
    // Author: Tomislav Busic
    //Importing Facebook (Tomislav Busic)
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
    }
    
    // Author: Tomislav Busic
    //Reads data from database. Called upon with every run of app
    func readDataFromDatabase() {
        
        players.removeAll()
        var db : OpaquePointer? = nil
        
        // if the database path is correct, continue
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            
            print("Successfully opened connection to database at \(self.databasePath)")
            var queryStatement : OpaquePointer? = nil
            // our select statement from the database to select all users
            let queryStatementString : String = "select * from users"
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                
                // while there is a row, collect all columns and put them into each field
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                    let id : Int = Int(sqlite3_column_int(queryStatement, 0))
                    let cname = sqlite3_column_text(queryStatement, 1)
                    let score = sqlite3_column_int(queryStatement, 2)
                    let name = String(cString: cname!)
                    let data : Player = Player.init()
                    
                    // insert data from database into our class model
                    data.initWithData(theRow: id, theName: name, theScore: Int(score))
                    
                    // add the model object into our array of scores
                    players.append(data)
                    
                }
                
            }
            else {
                // error message if statement could not be prepared
                print("Select statement could not be prepared")
                let error = String(cString: sqlite3_errmsg(db))
                print(error)
            }
            // close database connection
            sqlite3_close(db)
        }
        else {
            print("Unable to open database")
            
        }
        
    }
    
    // Author: Tomislav Busic
    //Inserts a new entry into the database
    func insertIntoDatabase(player : Player) -> Bool {
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            
            var insertStatement : OpaquePointer? = nil
            // insert statment string with prepared statement
            let insertStatementString : String = "insert into users values(NULL, ?, ?)"
            
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                
                //  get the player's name into variable
                let nameStr = player.getName() as NSString
                // get the player's score into variable
                let score = player.getScore()
                
                // bind the variables into the prepared statement
                sqlite3_bind_text(insertStatement, 1, nameStr.utf8String, -1, nil)
                sqlite3_bind_int(insertStatement, 2, Int32(score))
                // if everything went well, and the statement finished print success
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    let rowID = sqlite3_last_insert_rowid(db)
                    print("Successfully inserted row \(rowID)")
                }
                else {
                    // else if an error occurs, return false code and print an error
                    print("Could not insert row")
                    returnCode = false
                }
                sqlite3_finalize(insertStatement)
            }
            else {
                print("Insert statement could not be prepared")
                let error = String(cString: sqlite3_errmsg(db))
                print(error)
                returnCode = false
            }
            sqlite3_close(db)
        }
        else {
            print("Unable to open database")
            let error = String(cString: sqlite3_errmsg(db))
            print(error)
            returnCode = false
        }
        
        return returnCode
    }
    
    // Author: Tomislav Busic
    // Checks if database exists, if not it creates one.
    func checkAndCreateDatabase(){
        
        var success = false
        let fileManager = FileManager.default
        
        success = fileManager.fileExists(atPath: databasePath!)
        
        // if the database exists return a success code
        if success {
            return
        }
        
        // if database doesn't exist, try creating it
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName!)
        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
        
        return
    }
    
    // Author: Tomislav Busic
    // Clears the database table
    func clearTable() {
        var db : OpaquePointer? = nil
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            
            var deleteStatement : OpaquePointer? = nil
            let deleteStatementString : String = "DELETE FROM users"
            
            if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            
                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    print("Successfully deleted entries")
                }
                else {
                    print("Could not delete entries")
                }
                sqlite3_finalize(deleteStatement)
            }
            else {
                print("Statement could not be prepared")
                let error = String(cString: sqlite3_errmsg(db))
                print(error)
            }
            sqlite3_close(db)
        }
        else {
            print("Unable to open database")
            let error = String(cString: sqlite3_errmsg(db))
            print(error)
        }
    }
    
    // Author: Omar Kanawati
    // sets a default for music and sound effects across the application (Omar Kanawati)
    func setMusicAndEffects() {
        // sets url path for background music
        let musicURL = Bundle.main.path(forResource: "puzzle_music", ofType: "mp3")
        let url1 = URL(fileURLWithPath: musicURL!)
        musicPlayer = try! AVAudioPlayer.init(contentsOf: url1)
        musicPlayer?.currentTime = 0
        musicPlayer?.volume = menuOptions.getMusicVolume()
        musicPlayer?.numberOfLoops = -1
        
        if (menuOptions.getEffectsOn() == true){
            musicPlayer?.play()
        }
        
        let soundURL = Bundle.main.path(forResource: "click", ofType: "mp3")
        let url2 = URL(fileURLWithPath: soundURL!)
        soundPlayer = try! AVAudioPlayer.init(contentsOf: url2)
        soundPlayer?.currentTime = 0
        soundPlayer?.volume = menuOptions.getEffectsVolume()
        soundPlayer?.numberOfLoops = 0
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        // use the Firebase library to configure APIs
        FirebaseApp.configure()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

