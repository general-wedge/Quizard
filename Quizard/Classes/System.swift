//
//  System.swift
//  Quizard
//
//  Created by Xcode User on 2018-12-08.
//  Copyright © 2018 Xcode User. All rights reserved.
//

import Foundation
import UIKit

struct System {
    static func clearNavigationBar(forBar navBar: UINavigationBar) {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
    }
}
