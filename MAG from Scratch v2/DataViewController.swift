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

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        performSegue(withIdentifier: "logout", sender: self)
    }
    
}
