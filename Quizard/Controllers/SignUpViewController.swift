//
//  SignUpViewController.swift
//  FirebaseDemo
//
//  Created by Xcode User on 2018-11-11.
//  Copyright © 2018 Austin Howlett. All rights reserved.
//

import UIKit
import Firebase


class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    var ref: DatabaseReference?
    
    @IBOutlet var continueButton : UIButton!
    @IBOutlet var userNameText : UITextField!
    @IBOutlet var emailText : UITextField!
    @IBOutlet var passwordText : UITextField!
    
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    let gradientOne = UIColor(red: 48/255, green: 62/255, blue: 103/255, alpha: 1).cgColor
    let gradientTwo = UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 1).cgColor
    let gradientThree = UIColor(red: 196/255, green: 70/255, blue: 107/255, alpha: 1).cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let navController = navigationController {
            System.clearNavigationBar(forBar: navController.navigationBar)
            navController.view.backgroundColor = .clear
        }
        
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // set up controls
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
        continueButton.layer.borderWidth = 1
        continueButton.layer.borderColor = UIColor.white.cgColor
        
        let usernameBorder = CALayer()
        let width = CGFloat(2.0)
        usernameBorder.borderColor = UIColor.white.cgColor
        usernameBorder.frame = CGRect(x: 0, y: userNameText.frame.size.height - width, width:  userNameText.frame.size.width, height: userNameText.frame.size.height)
        
        usernameBorder.borderWidth = width
        userNameText.borderStyle = UITextField.BorderStyle.none
        userNameText.layer.addSublayer(usernameBorder)
        userNameText.layer.masksToBounds = true
        
        let emailBorder = CALayer()
        emailBorder.borderColor = UIColor.white.cgColor
        emailBorder.frame = CGRect(x: 0, y: userNameText.frame.size.height - width, width:  userNameText.frame.size.width, height: userNameText.frame.size.height)
        
        emailBorder.borderWidth = width
        emailText.borderStyle = UITextField.BorderStyle.none
        emailText.layer.addSublayer(emailBorder)
        emailText.layer.masksToBounds = true
        
        
        let passwordBorder = CALayer()
        passwordBorder.borderColor = UIColor.white.cgColor
        passwordBorder.frame = CGRect(x: 0, y: userNameText.frame.size.height - width, width:  userNameText.frame.size.width, height: userNameText.frame.size.height)
        
        passwordBorder.borderWidth = width
        passwordText.borderStyle = UITextField.BorderStyle.none
        passwordText.layer.addSublayer(passwordBorder)
        passwordText.layer.masksToBounds = true
        
    }
    
    @IBAction func signUp(sender: UIButton) {
        ref = Database.database().reference()
        Auth.auth().createUser(withEmail: self.emailText.text!, password: self.passwordText.text!) { (user, error) in
            if error != nil {
                print("Error occurred: \(error.debugDescription )");
                self.clearText()
            }
            
            if user != nil {
                print("User has been created")
                if let dbRef = self.ref {
                    if let signedInUser = user {
                        dbRef.child("users").child(signedInUser.user.uid).setValue(["userName": self.userNameText.text, "email": signedInUser.user.email])
                    }
                }
                self.performSegue(withIdentifier: "goToLogin", sender: self)
            }
        }
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clearText() {
        emailText.text = ""
        passwordText.text = ""
        userNameText.text = ""
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension SignUpViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}
