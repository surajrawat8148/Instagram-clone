//
//  AuthManager.swift
//  Instagram clone
//
//  Created by Suraj Rawat on 25/10/21.
//

import FirebaseAuth
import Foundation

public class AuthManager  {
    
    
    static let shared = AuthManager()
    
    public func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
    
        /*
         -check if username is available
         -check if email is available
         
         */
        DatabaseManager.shared.canCreateNewUser(with: email, username: username) { canCreate in
            if canCreate{
//                -create account
//                -insert account to database
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    guard error == nil, result != nil else{
                        completion(false)
//                      firebase auth could not create account 
                        return
                    }
                    
//                  insert into database
                    DatabaseManager.shared.insertNewUser(with: email, username: username) { inserted in
                        if inserted {
                            completion(true)
                            return
                        }
                        else{
//                          failed to insert to database
                            completion(false)
                            return
                        }
                    }
                    
                }
                
            }else {
                //            either email or username does not exist
                completion(false)
                
            }
        }
        
    }
    

    
    public func loginUser(username: String?, email: String?, password: String, completion: @escaping (Bool) -> Void){
        if let email = email{
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard authResult != nil,  error == nil else{
                    completion(false)
                    return
                }
                completion(true)
            }
        }
        else if let username = username{
//            username login
            print(username)
        }
    }
    
//    Attempt to logout firebase user
    public func logOut(completion: (Bool)-> Void){
        do{
            try Auth.auth().signOut()
            completion(true)
            return
        }
        catch{
            completion(false)
            print("Error")
            return
        }
    }
    
    

}
