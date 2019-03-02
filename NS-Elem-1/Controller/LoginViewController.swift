//
//  LoginViewController.swift
//  nsel-IntAdd
//
//  Created by Kyle Hernandez on 2/19/19.
//  Copyright © 2019 Eric Hernandez. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        Auth.auth().signIn(withEmail: userNameTxt.text!, password: passwordTxt.text!) { (user, error) in
            
            if error != nil {
                print(error!)
                print(error!._code)
                SVProgressHUD.dismiss()
            } else {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToApp", sender: self)
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
