//
//  LogInViewController.swift
//  Quizard
//
//  Author: Austin Howlett
//  UI Author: Austin Howlett
//  Description: The LoginViewController is responsible for handling authentication.
//               It handles user authorization by checking user credentials to what is
//               stored in Firebase under Authentication. If a user fails to login by providing
//               invalid values or no values at all, an alert is triggered notifying the user of
//               the error.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    @IBOutlet var emailText : UITextField!
    @IBOutlet var passwordText : UITextField!
    @IBOutlet var signInButton : UIButton!
    
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
        
        startBackgroundAnimation()
        readyView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: self.emailText.text!, password: self.passwordText.text!) { (user, error) in
            if error != nil {
                print("Error occurred: \(error.debugDescription )");
                self.showAlert(message: "[ERROR] Something failed while logging in. \n Please try again. \n Error Message: " +
                    "\(String(describing: error?.localizedDescription))")
                self.clearText()
            }
            
            if user != nil {
                print("User logged in")
                self.performSegue(withIdentifier: "goToApp", sender: self)
            } else {
                self.showAlert(message: "Invalid Email or Password \n Please try again.")
            }
        }
    }
    
    func clearText() {
        emailText.text = ""
        passwordText.text = ""
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
    
    func readyView() {
        ViewHelper.applyButtonStyles(button: signInButton)
        ViewHelper.applyInputStyles(input: emailText)
        ViewHelper.applyInputStyles(input: passwordText)
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

extension LogInViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}
