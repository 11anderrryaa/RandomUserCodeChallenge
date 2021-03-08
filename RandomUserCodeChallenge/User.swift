//
//  User.swift
//  RandomUserCodeChallenge
//
//  Created by Ryan Anderson on 3/5/21.
//

import Foundation

struct User : Codable {
    var name : String
    
    
    
    static func saveToFile(users: [User]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedUsers = try? propertyListEncoder.encode(users)
        try? encodedUsers?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadFromFile() -> [User] {
        let propertyListDecoder = PropertyListDecoder()
        if let  retrivedUsersData = try? Data(contentsOf: archiveURL),
           let decodedUsers = try? propertyListDecoder.decode(Array <User>.self, from: retrivedUsersData) {
            return decodedUsers
        }
        return []
    }
    
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("User").appendingPathExtension("plist")
}
