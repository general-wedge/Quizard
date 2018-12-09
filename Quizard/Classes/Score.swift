//
//  Score.swift
//  Quizard
//
//  Created by Xcode User on 2018-11-24.
//  Copyright © 2018 Xcode User. All rights reserved.
//

import Foundation


class Score {
    var userId: String
    var score: Int
    
    init(initialScore: Int, usersId: String) {
        score = initialScore
        userId = usersId
    }
    
    func updateScore() {
        score += 100
    }
    
    func updatePerfectScore() {
        score += 1000
    }
    
    func updateTimeScore(time: Int) {
        let timeScore = score / time
        
        if timeScore < 0 {
            score += 0
        } else {
            score += timeScore
        }
    }
}

// Not sure if we need the join table structs...
// Have to see how Firebase handles relationships
//struct Score_User {
//    var id: Int = 0
//    var userId: Int = 0
//    var scoreId: Int = 0
//}

struct HighScore {
    var userId: String
    var topic: Int
    var highScore: Int
}
