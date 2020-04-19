//
//  AppDelegate.swift
//  SudokuIOS
//
//  Created by Tomislav Busic on 2020-03-03.
//  Copyright © 2020 Tomislav Busic. All rights reserved.
//

import UIKit
import FacebookCore
import Foundation
import SQLite3
import Firebase
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var databaseName : String? = "ProjectDatabase.db"
    var databasePath : String?
    let defaults = UserDefaults.standard    // get the UserDefaults storage
    
    // array of scores and their winners' names
    var players : [Player] = []
    
    // the player that started the most recent game
    var currentPlayer : Player? = nil
    
    // audio players for music and sound effects
    var musicPlayer : AVAudioPlayer? = nil  // audio player for the puzzle music
    var winSoundPlayer : AVAudioPlayer? = nil   // audio player for the win sound effect
    var cellSoundPlayer : AVAudioPlayer? = nil  // audio player for the cell selection sound effect
    
    // save the game progress to userDefaults
    func saveProgress(game: Game) {
        // save the player name
        defaults.set(game.getPlayer().getName(), forKey: "playerName")
        
        // save the board array
        defaults.set(game.getBoard().getBoard2dArray(), forKey: "boardArray")
        
        // save the given cells of the board
        defaults.set(game.getGivenCells(), forKey: "givenCells")
        
        // synchronize the userDefaults
        defaults.synchronize()
    }
    
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
        
        return game
    }
    
    // delete the game progress data from userDefaults
    func deleteProgress() {
        defaults.removeObject(forKey: "playerName")
        defaults.removeObject(forKey: "boardArray")
        defaults.removeObject(forKey: "givenCells")
        // synchronize the changes with userDefaults
        defaults.synchronize()
    }
    
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
        return true
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
    
    //Importing Facebook (Tomislav Busic)
    @available(iOS 9.0, *)
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return ApplicationDelegate.shared.application(application, open: url, options: options)
    }
    //Importing Facebook (Tomislav Busic)
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
    }
    
    //Reads data from database. Called upon with every run of app
    func readDataFromDatabase() {
        
        players.removeAll()
        var db : OpaquePointer? = nil
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            
            
            print("Successfully opened connection to database at \(self.databasePath)")
            var queryStatement : OpaquePointer? = nil
            let queryStatementString : String = "select * from users"
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                    let id : Int = Int(sqlite3_column_int(queryStatement, 0))
                    let cname = sqlite3_column_text(queryStatement, 1)
                    let score = sqlite3_column_int(queryStatement, 2)
                    
                    
                    let name = String(cString: cname!)
                    
                    
                    let data : Player = Player.init()
                    
                    data.initWithData(theRow: id, theName: name, theScore: Int(score))
                    
                    
                    players.append(data)
                    
                }
                
            }
            else {
                print("Select statement could not be prepared")
                let error = String(cString: sqlite3_errmsg(db))
                print(error)
            }
            
            sqlite3_close(db)
        }
        else {
            print("Unable to open database")
            
        }
        
    }
    //Inserts a new entry into the database
    func insertIntoDatabase(player : Player) -> Bool {
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            
            var insertStatement : OpaquePointer? = nil
            let insertStatementString : String = "insert into users values(NULL, ?, ?)"
            
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                
                let nameStr = player.getName() as NSString
                let score = player.getScore()
                
                
                sqlite3_bind_text(insertStatement, 1, nameStr.utf8String, -1, nil)
                sqlite3_bind_int(insertStatement, 2, Int32(score))
                
                
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    let rowID = sqlite3_last_insert_rowid(db)
                    print("Successfully inserted row \(rowID)")
                }
                else {
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
    
    //Checks if database exists, if not it creates one.
    func checkAndCreateDatabase(){
        
        var success = false
        let fileManager = FileManager.default
        
        success = fileManager.fileExists(atPath: databasePath!)
        
        if success {
            return
        }
        
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName!)
        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
        
        return
    }
    
    //Clears database table
    func clearTable() -> Bool {
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            
            var deleteStatement : OpaquePointer? = nil
            let deleteStatementString : String = "DELETE FROM users"
            
            if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
                
                
                
                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    print("Successfully deleted entries")
                }
                else {
                    print("Could not delete entries")
                    returnCode = false
                }
                sqlite3_finalize(deleteStatement)
            }
            else {
                print("Statement could not be prepared")
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

