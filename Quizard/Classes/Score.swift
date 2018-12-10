//
//  Score.swift
//  Quizard
//
//  Author: Evan Kysley
//  Description: This is the Score and HighScore models used to store quiz score information
//               as well as HighScore information.


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
        var timeScore = 0
        if time != 0 {
            timeScore += score / time
        }
        
        if timeScore < 0 {
            score += 0
        } else {
            score += timeScore
        }
    }
}

struct HighScore {
    var topic: Int
    var highScore: Int
    
    init(highScoreTopic: Int, usersHighScore: Int) {
        topic = highScoreTopic
        highScore = usersHighScore
    }
}
