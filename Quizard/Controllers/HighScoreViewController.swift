//
//  HighScoreViewController.swift
//  Quizard
//
//  Created by Xcode User on 2018-12-06.
//  Copyright © 2018 Xcode User. All rights reserved.
//

import UIKit
import Firebase

class HighScoreViewController: UIViewController {

    var usersHighScores: [HighScore] = []
    var ref: DatabaseReference?
    
    @IBOutlet weak var artsScoreLabel: UILabel!
    @IBOutlet weak var scienceScoreLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var historyScoreLabel: UILabel!
    @IBOutlet weak var celebScoreLabel: UILabel!
    @IBOutlet weak var politicsScoreLabel: UILabel!
    @IBOutlet weak var sportsScoreLabel: UILabel!
    @IBOutlet weak var litScoreLabel: UILabel!
    @IBOutlet weak var techScoreLabel: UILabel!
    
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    let gradientOne = UIColor(red: 48/255, green: 62/255, blue: 103/255, alpha: 1).cgColor
    let gradientTwo = UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 1).cgColor
    let gradientThree = UIColor(red: 196/255, green: 70/255, blue: 107/255, alpha: 1).cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "High Scores"
        // Do any additional setup after loading the view.
        if let navController = navigationController {
            System.clearNavigationBar(forBar: navController.navigationBar)
            navController.view.backgroundColor = .clear
        }
        
        // get logged in users info and apply username to label
        getCurrentUserName() { (userName) in
            self.userLabel.text = "@" + userName
        }
        
        startBackgroundAnimation()
        for index in 0 ... 7 {
            getHighScore(topicIndex: index)
        }
        print(usersHighScores)
        
        readyView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startBackgroundAnimation()
        for index in 0 ... 7 {
            getHighScore(topicIndex: index)
        }
        readyView()
    }
    
    func getScoreText(topic: Int) -> String {
        guard let hs = usersHighScores[exist: topic] else {
            return "No high score yet"
        }
        return String(format: "%d points", hs.highScore)
    }
    
    func readyView() {
        ViewHelper.applyLabelStyles(label: historyScoreLabel, text: getScoreText(topic: 0))
        ViewHelper.applyLabelStyles(label: scienceScoreLabel, text: getScoreText(topic: 1))
        ViewHelper.applyLabelStyles(label: celebScoreLabel, text: getScoreText(topic: 2))
        ViewHelper.applyLabelStyles(label: politicsScoreLabel, text: getScoreText(topic: 3))
        ViewHelper.applyLabelStyles(label: sportsScoreLabel, text: getScoreText(topic: 4))
        ViewHelper.applyLabelStyles(label: artsScoreLabel, text: getScoreText(topic: 5))
        ViewHelper.applyLabelStyles(label: techScoreLabel, text: getScoreText(topic: 6))
        ViewHelper.applyLabelStyles(label: litScoreLabel, text: getScoreText(topic: 7))
    }
    
    func getHighScore(topicIndex: Int) {
        ref = Database.database().reference()
        let userId = getCurrentUserId()

        if let dbRef = ref {
            let key = String(format: "%@_%d", userId, topicIndex)
            let highScoreQuery = (dbRef.child("highscores").child(key))
            highScoreQuery.observeSingleEvent(of: .value, with: { (snapshot) in
                let dict = snapshot.value as? NSDictionary
                let highScore = dict?["highScore"] as? Int ?? 0
                let topic = dict?["topic"] as? Int ?? 0
                let highScoreObj = HighScore.init(highScoreTopic: topic, usersHighScore: highScore)
                self.usersHighScores.append(highScoreObj)
            })
        }
    }
    
    func getCurrentUserName(completion: @escaping (String) -> Void) {
        ref = Database.database().reference(withPath: "users")
        var userName: String = ""
        if let userRef = ref {
            userRef.child(getCurrentUserId()).observeSingleEvent(of: .value, with: { (snapshot) in
                let dict = snapshot.value as? NSDictionary ?? [:]
                userName = dict.value(forKey: "userName") as? String ?? ""
                completion(userName)
            })
        }
    }
    
    func getCurrentUserId() -> String {
        let currentUser = Auth.auth().currentUser
        if let user = currentUser {
            return user.uid
        }
        
        return ""
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

extension HighScoreViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}

extension Collection where Indices.Iterator.Element == Int {
    subscript (exist index: Int) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
