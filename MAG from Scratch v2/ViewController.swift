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


class ViewController: UIViewController {
    
    var username = ""
    var password = ""
    var userData = ""

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var masState = MAS.masState()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print ("--- Before MAS.start ---")
        print ("masState.rawValue: \(masState.rawValue)")
        var loggedIn = MASAuthenticationStatus.notLoggedIn.rawValue
        print ("Logged in? \(loggedIn)")

        print ("Auth status? \(MASAuthenticationStatus.RawValue())")
        
        
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

        

        print ("--- After MAS.start ---")
        print ("masState.rawValue: \(masState.rawValue)")
        loggedIn = MASAuthenticationStatus.notLoggedIn.rawValue
        print ("Logged in? \(loggedIn)")
        print ("Auth status? \(MASAuthenticationStatus.RawValue())")


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginBtn(_ sender: UIButton) {
        //Login the user with MAG
        
        username = usernameTextField.text!
        password = passwordTextField.text!
        
//        print ("Username is:  \(username)")
//        print ("Password is:  \(password)")
        
        SVProgressHUD.show(withStatus: "Starting MAS")
        
        MASUser.login(withUserName: username, password: password) { (completed, error) in
            print ("...Starting Login as: \(self.username)...")
            if (completed == true) {
                SVProgressHUD.dismiss()
                print ("MAS Login Successful!")
                print ("masState.rawValue: \(self.masState.rawValue)")
                
                let loggedIn = MASAuthenticationStatus.notLoggedIn.rawValue
                print ("Logged in? \(loggedIn)")
                print ("Auth status? \(MASAuthenticationStatus.RawValue())")


                SVProgressHUD.show(withStatus: "Retrieving Data")
                MAS.getFrom("/protected/resource/products", withParameters: ["operation":"listProducts"], andHeaders: nil, completion: { (response, error) in
                    SVProgressHUD.dismiss()
                    print("Products response: \(response?.debugDescription ?? "Error: No data returned.")")
                    self.userData = (response?.debugDescription)!
                    
                    //Perform segue now that we have data
                    self.performSegue(withIdentifier: "loggedIn", sender: self)
                })
                

                
//                print ("...Getting MAS User Info...")
//                MASUser.current()?.requestInfo(completion: { (masUser, error) in
//                    //print("1 \(masUser?.givenName ?? "empty")")
//                    //print("2 \(masUser?.familyName ?? "empty")")
//                    // print("3 \(masUser?.emailAddresses ?? "empty")")
//                    // print("4 \(masUser?.active ?? "empty")")
//                    //print("5 \(masUser?.accessToken ?? "empty")")
//
//                    self.userData = masUser?.debugDescription ?? "empty"
//                    //print("MAS Debug User Info: \(self.userData)")
//                    
//                    //Perform segue now that we have data
//                    self.performSegue(withIdentifier: "loggedIn", sender: self)
//                    
//                })
                
                
//                var builder = MASRequestBuilder.init(httpMethod: "GET")
//                builder.endPoint = "foo"
                
                
                
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
    
}

