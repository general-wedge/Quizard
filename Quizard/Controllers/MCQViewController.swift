//
//  MCQViewController.swift
//  FirebaseDemo
//
//  Created by Xcode User on 2018-11-12.
//  Copyright © 2018 Austin Howlett. All rights reserved.
//

import UIKit

class MCQViewController: UIViewController {

    var questionIndex: Int = 0

    @IBOutlet weak var labelQuestionIndex: UILabel!
    @IBOutlet weak var labelQuestionBody: UILabel!
    @IBOutlet weak var buttonOption1: UIButton!
    @IBOutlet weak var buttonOption2: UIButton!
    @IBOutlet weak var buttonOption3: UIButton!
    @IBOutlet weak var buttonOption4: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func submitChoice(sender: AnyObject) {
        //check if what we chose was correct
        guard let button = sender as? UIButton else {
            return
        }
        switch button.tag {
        case 1:
            verifyAnswer(answer: 1)
        case 2:
            verifyAnswer(answer: 2)
        case 3:
            verifyAnswer(answer: 3)
        case 4:
            verifyAnswer(answer: 4)
        default:
            print("unknown answer")
            return
        }
    }

    func verifyAnswer(answer: Int) {
        // firebase call or logic check against the selectedQuestionIndex
        print(answer)
    }

    func readyView() {
        // step 1: get data from the correct index
        // step 2: update ui pieces accordingly
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
