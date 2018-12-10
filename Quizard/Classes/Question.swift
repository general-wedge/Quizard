//
//  Question.swift
//  Quizard
//
//  Author: Austin Howlett
//  Description: This is the Question model used for the MCQ questions, it also has the
//               enum for each Topic.
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
