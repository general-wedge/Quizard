//
//  QuizScoreViewController.swift
//  Quizard
//
//  Author: Evan Kysley
//  UI Author: Evan Kysley
//  Description: The QuizScoreController is responsible for displaying the score information for
//               a quiz that user has just completed/taken. It will show the score achieved and the amount of questions
//               answered correctly

import UIKit
import Firebase

class QuizScoreViewController: UIViewController {

    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var rightAnswersLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var backToTopicsBtn: UIButton!
    
    var ref:  DatabaseReference?
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    let gradientOne = UIColor(red: 48/255, green: 62/255, blue: 103/255, alpha: 1).cgColor
    let gradientTwo = UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 1).cgColor
    let gradientThree = UIColor(red: 196/255, green: 70/255, blue: 107/255, alpha: 1).cgColor
    
    var usersScore: Score?
    var answerCount: Int?
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get logged in users info and apply username to label
        getCurrentUserName() { (userName) in
            self.userLabel.text = "@" + userName
        }
        startBackgroundAnimation()
        readyView()
    }
    
    func readyView() {
        ViewHelper.applyButtonStyles(button: backToTopicsBtn)
        // Do any additional setup after loading the view.
        if let score = usersScore,
            let rightAnswers = answerCount {
            ViewHelper.applyLabelStyles(label: rightAnswersLabel, text: "You Got: \(rightAnswers)/10 Questions Right!")
            ViewHelper.applyLabelStyles(label: scoreLabel, text: "You Scored: \(score.score) points.")
            if rightAnswers <= 3 {
                ViewHelper.applyLabelStyles(label: messageLabel, text: "You... you should probably go study.")
            } else if rightAnswers > 3 && rightAnswers <= 6 {
                ViewHelper.applyLabelStyles(label: messageLabel, text: "Not Bad. Practice makes perfect!")
            } else if rightAnswers >= 7 {
                ViewHelper.applyLabelStyles(label: messageLabel, text: "You are killing it. Way to go!")
            } else if rightAnswers == 10 {
                ViewHelper.applyLabelStyles(label: messageLabel, text: "Nailed it! Perfect Score!")
            }
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

extension QuizScoreViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}

