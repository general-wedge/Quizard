//
//  User.swift
//  Quizard
//
//  Author: Evan Kysley
//  Description: The User model which stories user information pulled from Firebase


import Foundation


struct User {
    var id: Int = 0
    var userName: String = ""
    var email: String = ""
    
    init(name: String, userEmail: String) {
        userName = name
        email = userEmail
    }
}
