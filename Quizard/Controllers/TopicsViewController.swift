//
//  TopicsViewController.swift
//  FirebaseDemo
//
//  Created by Xcode User on 2018-11-12.
//  Copyright © 2018 Austin Howlett. All rights reserved.
//

import UIKit
import Firebase

struct topicStruct {
    let name: String = ""
    let topicType: String = ""
}

class TopicsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

//    var dbHandle : DatabaseHandle?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let databaseRef : DatabaseReference
//        databaseRef = Database.database().reference()
//        dbHandle = databaseRef.child("Topics").queryOrderedByKey().observe(.childAdded) { (snapshot) in
//
//            // TODO: safely downcast/unwrap
//            let valueApp = snapshot.value as? String
//            let name : String! = valueApp!
//            print("Name: \(String(describing: name))")
//
//            //self.topics.insert(topicStruct(name: name), at: 0)
//            self.tableView.reloadData()
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell")
        
        let label1 = cell?.viewWithTag(1) as! UILabel
        label1.text = "Topic Text"
        
        return cell!
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
