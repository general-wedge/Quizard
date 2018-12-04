//
//  Question.swift
//  Quizard
//
//  Created by Xcode User on 2018-11-24.
//  Copyright © 2018 Xcode User. All rights reserved.
//

import Foundation

enum Topics: Int, CaseIterable {
    case History = 0
    case Science
    case Celebrities
    case Politics
    case Sports
    case Arts
    case Technology
    case Literature
    
    var nameEnum: String {
        return Mirror(reflecting: self).children.first?.label ?? String(describing: self)
    }
}

protocol Question {
    // index of the choice
    var answer: Int { get set }
    var topic: Int { get set }
}

extension Question {
    static func parseQuestionFields(jsonDict: [String:Any]) -> (Int, Int) {
        let answer = jsonDict["answer"] as! Int
        let topic = jsonDict["topic"] as! Int
        return (answer, topic)
    }
}

struct QuestionProxy: Question {
    var answer: Int
    var topic: Int
}

struct MCQ : Question {
    var answer: Int
    var topic: Int
    let questionText: String
    let choices: [String]
    init(jsonDict: [String:Any]) {
        (answer, topic) = QuestionProxy.parseQuestionFields(jsonDict: jsonDict)
        questionText = jsonDict["questionText"] as! String
        choices = jsonDict["choices"] as! [String]
    }
}

struct Pattern : Question {
    var answer: Int
    var topic: Int
    // image path
    var questionImage: String = ""
    var choices: [Int] = []
    // GARRET **** See below
    // not sure what format the pattern question choices are...
    // I'm assuming they are strings of the image path
    var choicesImages: [String] = []
}

struct Question_Score {
    var id: Int = 0
    var questionId: Int = 0
    var scoreId: Int = 0
}
