//
//  System.swift
//  Quizard
//
//  Author: Austin Howlett
//  Description: System struct handles general application tasks, for instance, making the navigation bar clear

import Foundation
import UIKit

struct System {
    static func clearNavigationBar(forBar navBar: UINavigationBar) {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
    }
}
