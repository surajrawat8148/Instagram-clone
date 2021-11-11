//
//  DatabaseManager.swift
//  Instagram clone
//
//  Created by Suraj Rawat on 25/10/21.
//

import FirebaseDatabase

public class DatabaseManager {
    
//    public
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
//    check if username and email is available
//    -Parameters
//          -email: String representing email
//          -username: String representing username
    public func canCreateNewUser(with email: String, username: String, completion: (Bool) -> Void) {
        completion(true)
        
    }
    
    //    insert new user to database
    //    -Parameters
    //          -email: String representing email
    //          -username: String representing username
//              -completion: Async callback for result if databse entry succeded
    public func insertNewUser(with email: String, username: String, completion: @escaping (Bool) ->Void) {
        database.child(email.safeDatabaseKey()).setValue(["username" : username]) { error, _ in
            if error == nil{
//                succeded
                completion(true)
            }
            else{
//                failed
                completion(false)
            }
        }
    }
    

}
