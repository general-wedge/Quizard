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
        
        // start background animation
        startBackgroundAnimation()
        // set up controls
        readyView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // start background animation
        startBackgroundAnimation()
        // set up controls
        readyView()
    }
    
    @IBAction func signUp(sender: UIButton) {
        ref = Database.database().reference()
        if !userNameText.text!.isEmpty {
            if !emailText.text!.isEmpty {
                if !passwordText.text!.isEmpty {
                    Auth.auth().createUser(withEmail: self.emailText.text!, password: self.passwordText.text!) { (user, error) in
                        if error != nil {
                            if let errorMessage = error {
                                self.showAlert(message: "Message: \(errorMessage.localizedDescription)")
                                print("Error occurred: \(error.debugDescription )");
                                self.clearText()
                            }
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
                } else {
                    self.showAlert(message: "Password is required.")
                }
            } else {
                self.showAlert(message: "Email is required.")
            }
        } else {
           self.showAlert(message: "Username is required.")
        }

    }
    
    func readyView() {
        ViewHelper.applyButtonStyles(button: continueButton)
        ViewHelper.applyInputStyles(input: userNameText)
        ViewHelper.applyInputStyles(input: emailText)
        ViewHelper.applyInputStyles(input: passwordText)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clearText() {
        emailText.text = ""
        passwordText.text = ""
        userNameText.text = ""
    }
    
    // creates an alert
    func createAlertController(message: String) -> UIAlertController {
        let alertController = UIAlertController(
            title: "Oops!",
            message: message,
            preferredStyle: .alert)
        // add cancel button so user can close alert
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        return alertController
    }
    
    // this function displays an alert
    func showAlert(message: String) {
        let alert = createAlertController(message: message)
        self.present(alert, animated: true, completion: nil)
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
