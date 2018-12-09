//
//  User.swift
//  Quizard
//
//  Created by Xcode User on 2018-11-24.
//  Copyright © 2018 Xcode User. All rights reserved.
//

import Foundation


struct User {
    var id: Int = 0
    var userName: String = ""
    var email: String = ""
    
    // default constructor
    init() { }
    
    init(name: String, userEmail: String) {
        userName = name
        email = userEmail
    }
}
