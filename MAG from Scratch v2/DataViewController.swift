//
//  DataViewController.swift
//  MAG from Scratch v2
//
//  Created by Matthew Keller on 9/13/18.
//  Copyright © 2018 Matthew Keller. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    
    var data = "You are logged in!"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print ("Hello from DataViewController")
        //print ("data is:  \(data)")
        dataLabel.text = data
    }

    
    //Logout Button
    @IBAction func logoutButton(_ sender: Any) {
        performSegue(withIdentifier: "logout", sender: self)
    }
    
    
    
    //Toggle the logoutRequested flag before segue to trigger a logout
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logout" {
            let dataVC = segue.destination as! ViewController
            dataVC.logoutRequested = true
        }
    }
    
    
}
