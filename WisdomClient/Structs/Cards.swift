//
//  Cards.swift
//  WisdomClient
//
//  Created by Sergio Infante on 2/7/17.
//  Copyright © 2017 Sergio Infante. All rights reserved.
//

import Foundation


struct Card {
    let id: Int!
    let title: String
    let isTitleVisible: Bool
    let text: String
    let secondaryText: String?
    let image: String?
    let createdBy: User!
    let updatedBy: User!
    let author: String
    
    static func parse(dictionary: NSDictionary!) -> Card {
        let id = dictionary["id"] as! Int
        let title = dictionary["title"] as! String
        let isTitleVisible = dictionary["is_title_visible"] as! Bool
        let text = dictionary["text"] as! String
        let secondaryText = dictionary["secondary_text"] as? String
        let image = dictionary["image"] as? String
        let createdBy = User.parse(dictionary: dictionary["created_by"] as? NSDictionary)
        let updatedBy = User.parse(dictionary: dictionary["updated_by"] as? NSDictionary)
        let author = dictionary["author"] as! String
        return Card.init(id: id, title: title, isTitleVisible: isTitleVisible, text: text, secondaryText: secondaryText, image: image, createdBy: createdBy, updatedBy: updatedBy, author: author)
    }
}

struct User {
    let username: String
    let firstName: String
    let lastName: String
    let isStaff: Bool
    let isActive: Bool
    let email: String
    
    static func parse(dictionary: NSDictionary!) -> User{
        var username: String = ""
        var firstName: String = ""
        var lastName: String = ""
        var isStaff: Bool = false
        var isActive: Bool = false
        var email: String = ""
        
        if let parsedUser = dictionary {
            username = parsedUser["username"] as! String
            firstName = parsedUser["first_name"] as! String
            lastName = parsedUser["last_name"] as! String
            isStaff = parsedUser["is_staff"] as! Bool
            isActive = parsedUser["is_active"] as! Bool
            email = parsedUser["email"] as! String
        }
        
        return User(username: username, firstName: firstName, lastName: lastName, isStaff: isStaff, isActive: isActive, email: email)
    }
}
