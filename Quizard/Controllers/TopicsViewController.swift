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
    var ref: DatabaseReference?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Topics"
        tableView.delegate = self
        tableView.dataSource = self
        //initQuestions()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Topics.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell", for: indexPath)
        
        // get value of enum by the raw value (Int)
        let enumValue: Topics? = Topics(rawValue: indexPath.row)
        // cast the enum name value to String
        let enumStringValue = enumValue?.nameEnum
        cell.textLabel?.text = enumStringValue
        
        return cell
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
                }
                self.performSegue(withIdentifier: "topicSegue", sender: self)
            }
        }
       
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "topicSegue"
        {
            if let vc = segue.destination as? MCQViewController {
                // pass chosen mcqs to mcq view controller
                vc.chosenTopicQuestion = self.mcqs
            }
        }
    }
    
    func initQuestions() {
        ref = Database.database().reference()
        if let dbRef = ref {
            
            dbRef.child("questions").childByAutoId().setValue(["answer": 1, "topic": 0, "questionText": "Canada was founded in which year?", "choices": ["1776", "1867", "1432", "1676"]])
            
            dbRef.child("questions").childByAutoId().setValue(["answer": 3, "topic": 0, "questionText": "In what year did Christopher Columbus so famously sail the ocean blue?", "choices": ["1352", "1682", "1542", "1492"]])
            
            dbRef.child("questions").childByAutoId().setValue(["answer": 2, "topic": 0, "questionText": "The first known civilization, located in mordern-day Iraq, is called?", "choices": ["Sumer", "Babylonia", "Mesopotamia", "Aramaic"]])
            
            dbRef.child("questions").childByAutoId().setValue(["answer": 0, "topic": 0, "questionText": "The first human life to set foot in North America is most likely from?", "choices": ["Asia", "Africa", "Europe", "Australia"]])
            
            dbRef.child("questions").childByAutoId().setValue(["answer": 1, "topic": 0, "questionText": "The White House was burned down in which year?", "choices": ["1945", "1814", "1780", "1880"]])
            
            dbRef.child("questions").childByAutoId().setValue(["answer": 2, "topic": 0, "questionText": "Napoleon Bonaparte was exiled to which island in 1814?", "choices": ["Maldives", "Klingking", "Elba", "Cape Breton"]])
            
            dbRef.child("questions").childByAutoId().setValue(["answer": 0, "topic": 0, "questionText": "Ancient Egypt is described being which time period?", "choices": ["3100 BC to 525 BC", "4500 BC to 1000 BC", "2750 BC to 750 BC", "5000 BC to 2000 BC"]])
            
            dbRef.child("questions").childByAutoId().setValue(["answer": 1, "topic": 0, "questionText": "Which famous Roman emperor was overthrown by germanic barbarians in 476 CE?", "choices": ["Nero", "Romulus", "Remus", "Caesar"]])
            
            dbRef.child("questions").childByAutoId().setValue(["answer": 2, "topic": 0, "questionText": "Which Roman emperor was the first to be assassinated?", "choices": ["Caesar", "Nero", "Caligula", "Tiberius"]])
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
