//
//  TopicsViewController.swift
//  FirebaseDemo
//
//  Created by Xcode User on 2018-11-12.
//  Copyright © 2018 Austin Howlett. All rights reserved.
//

import UIKit
import Firebase

class TopicsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var mcqs: [MCQ] = []
    var topic: Int = 0
    var ref: DatabaseReference?
    
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    let gradientOne = UIColor(red: 48/255, green: 62/255, blue: 103/255, alpha: 1).cgColor
    let gradientTwo = UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 1).cgColor
    let gradientThree = UIColor(red: 196/255, green: 70/255, blue: 107/255, alpha: 1).cgColor
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Topics"
        tableView.delegate = self
        tableView.dataSource = self
        
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        startBackgroundAnimation()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Topics.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell", for: indexPath)
        tableView.backgroundColor = .clear
        // get value of enum by the raw value (Int)
        let enumValue: Topics? = Topics(rawValue: indexPath.row)
        // cast the enum name value to String
        if let enumStringValue = enumValue?.nameEnum {
            ViewHelper.applyCellLabelStyles(label: cell.textLabel, text: enumStringValue)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let minHeight: CGFloat = 100.0
        let tHeight = tableView.bounds.height
        let temp = tHeight/CGFloat(Topics.allCases.count)
        return temp > minHeight ? temp : minHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ref = Database.database().reference()
        if let dbRef = ref {
            let selectedTopicQuery = (dbRef.child("questions").queryOrdered(byChild: "topic").queryEqual(toValue: indexPath.row))
            selectedTopicQuery.observe(.value) { snapshot in
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let dict = child.value as? [String: Any] else { continue }
                    let mcq = MCQ.init(jsonDict: dict)
                    self.mcqs.append(mcq)
                    self.topic = indexPath.row
                }
                self.performSegue(withIdentifier: "topicSegue", sender: self)
            }
        }
        // animate the click
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "topicSegue"
        {
            if let vc = segue.destination as? MCQViewController {
                // pass chosen mcqs to mcq view controller
                vc.topic = self.topic
                vc.chosenTopicQuestion = self.mcqs
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

extension TopicsViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}
