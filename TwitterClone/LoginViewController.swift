//
//  InitialViewController.swift
//  TwitterClone
//
//  Created by Shoya Ishimaru on 2015/05/08.
//  Copyright (c) 2015年 shoya140. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: FUITextField!
    @IBOutlet weak var passwordTextField: FUITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signInButtonTapped(sender: AnyObject) {
        self.login(self.usernameTextField.text, password: self.passwordTextField.text)
    }
    
    @IBAction func signUpButtonTapped(sender: AnyObject) {
        if count(self.usernameTextField.text) == 0 || count(self.passwordTextField.text) == 0 {
            return
        }
        var user = PFUser()
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? String
                println("error: \(errorString)")
            } else {
                self.login(self.usernameTextField.text, password: self.passwordTextField.text)
            }
        }
    }
    
    func login(username: String, password: String) {
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? String
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}