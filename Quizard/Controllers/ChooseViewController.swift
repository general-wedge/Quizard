//
//  ChooseViewController.swift
//  FirebaseDemo
//
//  Created by Xcode User on 2018-11-12.
//  Copyright © 2018 Austin Howlett. All rights reserved.
//

import UIKit
import Firebase

class ChooseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var ref: DatabaseReference?
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    let gradientOne = UIColor(red: 48/255, green: 62/255, blue: 103/255, alpha: 1).cgColor
    let gradientTwo = UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 1).cgColor
    let gradientThree = UIColor(red: 196/255, green: 70/255, blue: 107/255, alpha: 1).cgColor
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up view
        tableView.delegate = self
        tableView.dataSource = self
        // hide back button
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        if let navController = navigationController {
            System.clearNavigationBar(forBar: navController.navigationBar)
            navController.view.backgroundColor = .clear
        }
        
        // get logged in users info and apply username to label
        getCurrentUserName() { (userName) in
            self.userLabel.text = "@" + userName
        }
        
        startBackgroundAnimation()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        tableView.backgroundColor = .clear
        if indexPath.row == 0 {
            ViewHelper.applyCellLabelStyles(label: cell.textLabel, text: "Question Topics")
        } else if indexPath.row == 1 {
            ViewHelper.applyCellLabelStyles(label: cell.textLabel, text: "High Scores")
        } else if indexPath.row == 2 {
            ViewHelper.applyCellLabelStyles(label: cell.textLabel, text: "Profile")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "goToTopics", sender: self)
        } else if indexPath.row == 1 {
            self.performSegue(withIdentifier: "goToHighScores", sender: self)
        } else if indexPath.row == 2 {
            self.performSegue(withIdentifier: "goToProfile", sender: self)
        }
        // animate the click
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let minHeight: CGFloat = 100.0
        let tHeight = tableView.bounds.height
        let temp = tHeight/CGFloat(4)
        return temp > minHeight ? temp : minHeight
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
            // TODO: handle error properly OR update to handle method in firebase
            // TODO: moved it from guard let (try re working it later)
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

extension ChooseViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}
