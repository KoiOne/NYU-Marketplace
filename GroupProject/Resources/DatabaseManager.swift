//
//  DatabaseManager.swift
//  GroupProject
//
//  Created by Xingyu Wang on 4/23/22.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager{
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    
}

extension DatabaseManager {
    public func userExists(with email: String, completion: @escaping ((Bool) -> Void)){
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with:{snapshot in
            guard snapshot.value as? String != nil else{
                completion(false)
                    return
            }
            
            completion(true)
        })
    }
    
    public func insertUser(with user: ChatAppUser) {
        database.child(user.safeEmail).setValue([
            "username": user.username
        ])
    }
}

struct ChatAppUser {
    let username: String
    let emailAddress: String
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
