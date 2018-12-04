//
//  Score.swift
//  Quizard
//
//  Created by Xcode User on 2018-11-24.
//  Copyright © 2018 Xcode User. All rights reserved.
//

import Foundation


struct Score {
    var userId: Int = 0
    var score: Int = 0
}

// Not sure if we need the join table structs...
// Have to see how Firebase handles relationships
//struct Score_User {
//    var id: Int = 0
//    var userId: Int = 0
//    var scoreId: Int = 0
//}

struct HighScore {
    var userId: Int = 0
    var questionId: Int = 0
    var scoreId: Int = 0
}
