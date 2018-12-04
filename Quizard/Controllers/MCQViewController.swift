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
    var chosenTopicQuestion: [MCQ]?

    @IBOutlet weak var labelQuestionIndex: UILabel!
    @IBOutlet weak var labelQuestionBody: UILabel!
    @IBOutlet weak var buttonOption1: UIButton!
    @IBOutlet weak var buttonOption2: UIButton!
    @IBOutlet weak var buttonOption3: UIButton!
    @IBOutlet weak var buttonOption4: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let questions = chosenTopicQuestion {
            // get value of enum by the raw value (Int)
            let enumValue: Topics? = Topics(rawValue: questions[questionIndex].topic)
            // cast the enum name value to String
            if let enumStringValue = enumValue?.nameEnum {
                self.title = "\(enumStringValue)"
            }
        }
        readyView()
    }

    @IBAction func submitChoice(sender: AnyObject) {
        //check if what we chose was correct
        guard let button = sender as? UIButton else {
            return
        }
        switch button.tag {
        case 1:
            verifyAnswer(answer: 0)
            questionIndex = questionIndex + 1
            readyView()
        case 2:
            verifyAnswer(answer: 1)
            questionIndex = questionIndex + 1
            readyView()
        case 3:
            verifyAnswer(answer: 2)
            questionIndex = questionIndex + 1
            readyView()
        case 4:
            verifyAnswer(answer: 3)
            questionIndex = questionIndex + 1
            readyView()
        default:
            print("unknown answer")
            return
        }
    }

    func verifyAnswer(answer: Int) {
        // firebase call or logic check against the selectedQuestionIndex
        if let questions = chosenTopicQuestion {
            if answer == questions[questionIndex].answer {
                // update score
            }
        }
        print(answer)
    }

    func readyView() {
        if questionIndex <= 9 {
            if let questions = self.chosenTopicQuestion {
                labelQuestionIndex.text = "Question \(questionIndex + 1)"
                labelQuestionBody.text = questions[questionIndex].questionText
                buttonOption1.setTitle("A: \(questions[questionIndex].choices[0])", for: UIControl.State.normal)
                buttonOption2.setTitle("B: \(questions[questionIndex].choices[1])", for: UIControl.State.normal)
                buttonOption3.setTitle("C: \(questions[questionIndex].choices[2])", for: UIControl.State.normal)
                buttonOption4.setTitle("D: \(questions[questionIndex].choices[3])", for: UIControl.State.normal)
            }
        }
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
