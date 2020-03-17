//
//  Database.swift
//  sudoko
//
//  Created by Xcode User on 2020-03-04.
//  Copyright © 2020 Tomislav Busic. All rights reserved.
//

import Foundation
import SQLite3

class Database {
    
    init() {
        db = openDatabase()
        createPlayerTable()
    }
    
    private func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?
    
    private func createPlayerTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS player(Id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,score INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("player table created.")
            } else {
                print("player table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    //prepared statement adding person
    let addPersonStatement = "INSERT INTO person (Name, Score) VALUES (?, ?);"
    
    //function to call adding person
    func addPerson(name : NSString, score : Int32) {
        var insertStatement: OpaquePointer?
        // compiles SQL statement
        if sqlite3_prepare_v2(db, addPersonStatement, -1, &insertStatement, nil) ==
            SQLITE_OK {
            
            // binding our insert statements
            sqlite3_bind_int(insertStatement, 1, score)
            
            sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil)
            // running the statement
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully inserted row.")
            } else {
                print("\nCould not insert row.")
            }
        } else {
            print("\nINSERT statement is not prepared.")
        }
        // deletion of SQL statement to avoid leakage
        sqlite3_finalize(insertStatement)
    }
    
    let queryAllPlayers = "SELECT * FROM Contact;"
    
    func queryDatabase() {
        var queryStatement: OpaquePointer?
        if sqlite3_prepare_v2(
            db,
            queryAllPlayers,
            -1,
            &queryStatement,
            nil
            ) == SQLITE_OK {
            print("\n")
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let id = sqlite3_column_int(queryStatement, 0)
                guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
                    print("Query result is nil.")
                    return
                }
                let name = String(cString: queryResultCol1)
                print("Query Result:")
                print("\(id) | \(name)")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
    }
    
    
    
    let clearPlayers = "DELETE * FROM player"
    //function to delete all records
    func delete() {
        var deleteStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, clearPlayers, -1, &deleteStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("\nDeleted all from player.")
            } else {
                print("\nCould not deleete rows.")
            }
        } else {
            print("\nDELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    
    
    
}

