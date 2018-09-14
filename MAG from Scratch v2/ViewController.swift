//
//  ViewController.swift
//  MAG from Scratch v2
//
//  Created by Matthew Keller on 9/13/18.
//  Copyright © 2018 Matthew Keller. All rights reserved.
//

import UIKit
import MASFoundation
import SVProgressHUD
import SwiftyJSON



class ViewController: UIViewController {
    
    var username = ""
    var password = ""
    var userData = ""
    var logoutRequested = false

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var masState = MAS.masState()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Debugging Info in the absense of documentation
        print ("--- Before MAS.start ---")
        print ("masState.rawValue: \(masState.rawValue)")
        var loggedIn = MASAuthenticationStatus.notLoggedIn.rawValue
        print ("Logged in? \(loggedIn)")
        print ("Auth status? \(MASAuthenticationStatus.RawValue())")
        print ("Logout requested?: \(logoutRequested)")
        
        
        //Handle logoutRequested
        if logoutRequested == true {
            logout()
            logoutRequested = false
        }
        
        
        //Start MAS
        MAS.setGrantFlow(MASGrantFlow.password)
        MAS.start(withDefaultConfiguration: true) { (completed, error) in
            SVProgressHUD.show(withStatus: "Starting MAS")
            print ("...Starting MAS!")
            if (completed == true) {
                SVProgressHUD.dismiss()
                print ("MAS START COMPLETED!")
            } else {
                print ("MAS   NOT   STARTED.  Errors: ")
                print (error!)
            }
        }

        
        //Debugging Info in the absense of documentation
        print ("--- After MAS.start ---")
        print ("masState.rawValue: \(masState.rawValue)")
        loggedIn = MASAuthenticationStatus.notLoggedIn.rawValue
        print ("Logged in? \(loggedIn)")
        print ("Auth status? \(MASAuthenticationStatus.RawValue())")
    }

    
    

    //Login the user with MAG
    @IBAction func loginBtn(_ sender: UIButton) {
        username = usernameTextField.text!
        password = passwordTextField.text!
        
        SVProgressHUD.show(withStatus: "Performing Login")

        //Try Login
        MASUser.login(withUserName: username, password: password) { (completed, error) in
            print ("...Starting Login as: \(self.username)...")

            //Login worked
            if (completed == true) {
                SVProgressHUD.dismiss()
                print ("MAS Login Successful!")
                print ("masState.rawValue: \(self.masState.rawValue)")
                
                let loggedIn = MASAuthenticationStatus.notLoggedIn.rawValue
                print ("Logged in? \(loggedIn)")
                print ("Auth status? \(MASAuthenticationStatus.RawValue())")

                
                //Retrieve data
                SVProgressHUD.show(withStatus: "Retrieving Data")
                MAS.getFrom("/protected/resource/products", withParameters: ["operation":"listProducts"], andHeaders: nil, completion: { (response, error) in
                    SVProgressHUD.dismiss()
                    
                    ////////print("Products response: \(response?.debugDescription ?? "Error: No data returned.")")
                    

 
//                    //Parse JSON
//                    print("Try to parse JSON...")
//                    let resultJSON : JSON = JSON(response!)
//                    if let products = resultJSON["MASResponseInfoBodyInfoKey"]["products"]["name"].string {
//                        print ("Products: \(products)")
//                    } else {
//                        print ("Error parsing JSON")
//                    }

                    //Send raw data instead of parsed json
                    self.userData = (response?.debugDescription)!
                    
                    //Perform segue now that we have data
                    self.performSegue(withIdentifier: "loggedIn", sender: self)
                })
                
            } else {
                print ("MAS Login   NOT successful.  Errors: ")
                print (error!)
            }
        }
    }
    
    
    
    //Pass data over segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loggedIn" {
            let dataVC = segue.destination as! DataViewController
            dataVC.data = self.userData
            
        }
    }
    
    
    
    //Logout  -- Adapted from Alan Cota example
    func logout () {
        
        if (MASUser.current() != nil) {
            if (MASUser.current()!.isAuthenticated) {
                MASUser.current()?.logout(false, completion: { (completed, error) in    //updated logout funk
                    
                    if (error != nil) {
                        print("Error trying to logout the user")
                        //Present an Alert showing the results
                        let alertController = UIAlertController(title: "Error", message: "The user coudl not be logged out", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        print("User logout was successful")
                        //Present an Alert showing the results
                        let alertController = UIAlertController(title: "User Logout", message: "The user has been logged out!", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                })
            }
        }
        
        
    }
    
    
    
    
    
    
}

