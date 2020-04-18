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
    var people : [MyData] = []
    var gameOptions : GameOptions = [.easy, .background1]
    var menuOptions = MenuOptions(musicOn: true, musicVolume: 5, effectsOn: true, effectsVolume: 10, darkMode: false)
    
    
    // testing sound options for entire application
    var musicPlayer : AVAudioPlayer?
    var soundPlayer : AVAudioPlayer?
    
    // array that contains different game mode icons and background choices
    var imgData = ["sudoku_easy.png", "sudoku_normal.png", "sudoku_hard.png", "watercolor.jpg", "clouds.jpg"]
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir = documentPaths[0]
        databasePath = documentsDir.appending("/" + databaseName!)
        checkAndCreateDatabase()
        readDataFromDatabase()
        setMusicAndEffects()
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
        
        people.removeAll()
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
                    
                    
                    let data : MyData = MyData.init()
                    
                    data.initWithData(theRow: id, theName: name, theScore: Int(score))
                    
                    
                    people.append(data)
                    
                    print("Query result")
                    
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
    func insertIntoDatabase(person : MyData) -> Bool {
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            
            var insertStatement : OpaquePointer? = nil
            var insertStatementString : String = "insert into users values(NULL, ?, ?)"
            
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                
                let nameStr = person.name! as NSString
                let score = person.score!
                
                
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
            var deleteStatementString : String = "DELETE FROM users"
            
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
    
    // sets a default for music and sound effects across the application
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
    
}

