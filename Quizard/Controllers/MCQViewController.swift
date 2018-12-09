//
//  MCQViewController.swift
//  FirebaseDemo
//
//  Created by Xcode User on 2018-11-12.
//  Copyright © 2018 Austin Howlett. All rights reserved.
//

import UIKit
import Firebase

class MCQViewController: UIViewController {

    // properties
    var questionIndex: Int = 0
    var topic: Int?
    var rightAnswerCount: Int = 0
    var score: Score?
    var chosenTopicQuestion: [MCQ]?
    var ref: DatabaseReference?
    var timer: Timer!
    var counter: Float = 0.00
    
    // gradients
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    let gradientOne = UIColor(red: 48/255, green: 62/255, blue: 103/255, alpha: 1).cgColor
    let gradientTwo = UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 1).cgColor
    let gradientThree = UIColor(red: 196/255, green: 70/255, blue: 107/255, alpha: 1).cgColor

    // controls
    @IBOutlet weak var labelQuestionIndex: UILabel!
    @IBOutlet weak var labelQuestionBody: UILabel!
    @IBOutlet weak var buttonOption1: UIButton!
    @IBOutlet weak var buttonOption2: UIButton!
    @IBOutlet weak var buttonOption3: UIButton!
    @IBOutlet weak var buttonOption4: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let chosenTopic = topic {
            // get value of enum by the raw value (Int)
            let enumValue: Topics? = Topics(rawValue: chosenTopic)
            // cast the enum name value to String
            if let enumStringValue = enumValue?.nameEnum {
                self.title = "\(enumStringValue)"
            }
        }
        
        timerLabel.text = String(counter)
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] timer in
            
            // this allows us to use the ViewControllers self
            // rather than the completion handlers self
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.counter += 0.01
            ViewHelper.applyLabelStyles(label: strongSelf.timerLabel, text: String(format: "%0.2f", strongSelf.counter))
        }
        startBackgroundAnimation()
        readyView()
    }

    @IBAction func submitChoice(sender: AnyObject) {
        //check if what we chose was correct
        guard let button = sender as? UIButton else {
            return
        }
        
        // quiz is done otherwise check for the answer
        if questionIndex == 9 {
            checkForHighScore()
        } else {
            switch button.tag {
                case 1:
                    verifyAnswer(answer: 0)
                    updateQuestionIndex()
                    readyView()
                case 2:
                    verifyAnswer(answer: 1)
                    updateQuestionIndex()
                    readyView()
                case 3:
                    verifyAnswer(answer: 2)
                    updateQuestionIndex()
                    readyView()
                case 4:
                    verifyAnswer(answer: 3)
                    updateQuestionIndex()
                    readyView()
                default:
                    print("unknown answer")
                    return
            }
        }
    }
    
    func updateQuestionIndex() {
        if questionIndex < 9 {
            questionIndex = questionIndex + 1
        }
    }

    func verifyAnswer(answer: Int) {
        if let questions = chosenTopicQuestion {
            if answer == questions[questionIndex].answer {
                // update score
                rightAnswerCount += 1
                updateScore()
            }
        }
    }
    
    func updateScore() {
        let userId = getCurrentUserId()
        if score == nil {
            score = Score.init(initialScore: 100, usersId: userId)
        } else {
            if let score = score {
                score.updateScore()
                
                if rightAnswerCount == 10 {
                    score.updatePerfectScore()
                }
            }
        }
    }
    
    func getCurrentUserId() -> String {
        let currentUser = Auth.auth().currentUser
        if let user = currentUser {
            // TODO: handle error properly OR update to handle method in firebase
            // TODO: moved it from guard let (try re working it later)
            return user.uid
        }
        
        return ""
    }
    
    
    func checkForHighScore() {
        timer.invalidate()
        let answerCount = rightAnswerCount
        guard let usersScore = score else { return }
        guard let chosenTopic = topic else { return }
        let key = String(format: "%@_%d", usersScore.userId, chosenTopic)
        usersScore.updateTimeScore(time: Int(counter))
        ref = Database.database().reference()
        if let dbRef = ref {
            let usersHighScoreQuery = (dbRef.child("highscores").child(key).queryOrdered(byChild: "userId").queryEqual(toValue: usersScore.userId))
            usersHighScoreQuery.observeSingleEvent(of: .value, with: { (snapshot) in
                let dict = snapshot.value as? NSDictionary ?? nil
                if dict == nil {
                    dbRef.child("highscores").child(key).setValue(["topic": chosenTopic, "highScore": usersScore.score])
                } else {
                    // TODO: Update users highscore
                    if let rootDict = dict {
                        let valueDict = rootDict.value(forKey: key) as? NSDictionary
                        if let storedHighScore = valueDict {
                            // force casting because we know we have a highscore in our database
                            if usersScore.score > storedHighScore["highScore"] as! Int {
                                let newHighScore = [ "topic": chosenTopic, "highScore": usersScore.score] as [String : Any]
                                let updateUsersHighScore = ["/highscores/\(key)": newHighScore]
                                dbRef.updateChildValues(updateUsersHighScore)
                            }
                        }
                    }
                }
                // TODO: maybe move this into completion handler of checkHighScore()
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "QuizScoreVC") as! QuizScoreViewController
                // pass data
                vc.usersScore = usersScore
                vc.answerCount = answerCount
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
    }

    func readyView() {
        ViewHelper.applyButtonStyles(button: buttonOption1)
        ViewHelper.applyButtonStyles(button: buttonOption2)
        ViewHelper.applyButtonStyles(button: buttonOption3)
        ViewHelper.applyButtonStyles(button: buttonOption4)
        if let questions = self.chosenTopicQuestion {
            ViewHelper.applyLabelStyles(label: labelQuestionIndex, text: "Question \(questionIndex + 1)")
            ViewHelper.applyLabelStyles(label: labelQuestionBody, text: questions[questionIndex].questionText)
            buttonOption1.setTitle("A: \(questions[questionIndex].choices[0])", for: UIControl.State.normal)
            buttonOption2.setTitle("B: \(questions[questionIndex].choices[1])", for: UIControl.State.normal)
            buttonOption3.setTitle("C: \(questions[questionIndex].choices[2])", for: UIControl.State.normal)
            buttonOption4.setTitle("D: \(questions[questionIndex].choices[3])", for: UIControl.State.normal)
        }
    }
    
    func startBackgroundAnimation() {
        // set up gradient animation
        gradientSet.append([gradientOne, gradientTwo])
        gradientSet.append([gradientTwo, gradientThree])
        gradientSet.append([gradientThree, gradientOne])
        
        gradient.frame = self.view.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.drawsAsynchronously = true
        self.view.layer.insertSublayer(gradient, at: 0)
        
        animateGradient()
    }
    
    func animateGradient() {
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 5.0
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradientChangeAnimation.delegate = self
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MCQViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}
