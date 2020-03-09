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
        createTable()
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
    
    private func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS player(Id INTEGER PRIMARY KEY,name TEXT,score INTEGER);"
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
    
}

