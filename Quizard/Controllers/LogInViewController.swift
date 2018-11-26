//
//  LogInViewController.swift
//  FirebaseDemo
//
//  Created by Xcode User on 2018-03-24.
//  Copyright © 2018 Austin Howlett. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    @IBOutlet var emailText : UITextField!
    @IBOutlet var passwordText : UITextField!
    @IBOutlet var signInButton : UIButton!
    
    @IBAction func logIn(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: self.emailText.text!, password: self.passwordText.text!) { (user, error) in
            if error != nil {
                print("Error occurred: \(error.debugDescription )");
            }
            
            if user != nil {
                print("User logged in")
                //self.clearText()
                self.performSegue(withIdentifier: "goToApp", sender: self)
            } else {
                print("User failed to login")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 125/255.5, green: 175/255.5, blue: 255/255.5, alpha: 1.0).cgColor, UIColor(red: 128/255.5, green: 25/255.5, blue: 14/255.5, alpha: 1.0).cgColor,
                                UIColor(red: 128/255.5, green: 25/255.5, blue: 14/255.5, alpha: 1.0).cgColor]
        gradientLayer.locations = [0.0, 0.8, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        signInButton.backgroundColor = .clear
        signInButton.layer.cornerRadius = signInButton.frame.height / 2
        signInButton.layer.borderWidth = 1
        signInButton.layer.borderColor = UIColor.white.cgColor
        
        let width = CGFloat(2.0)
        let emailBorder = CALayer()
        emailBorder.borderColor = UIColor.white.cgColor
        emailBorder.frame = CGRect(x: 0, y: emailText.frame.size.height - width, width:  emailText.frame.size.width, height: emailText.frame.size.height)
        
        emailBorder.borderWidth = width
        emailText.borderStyle = UITextField.BorderStyle.none
        emailText.layer.addSublayer(emailBorder)
        emailText.layer.masksToBounds = true
        
        
        let passwordBorder = CALayer()
        passwordBorder.borderColor = UIColor.white.cgColor
        passwordBorder.frame = CGRect(x: 0, y: passwordText.frame.size.height - width, width:  passwordText.frame.size.width, height: passwordText.frame.size.height)
        
        passwordBorder.borderWidth = width
        passwordText.borderStyle = UITextField.BorderStyle.none
        passwordText.layer.addSublayer(passwordBorder)
        passwordText.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
