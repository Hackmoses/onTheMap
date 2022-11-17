//
//  ViewController.swift
//  onTheMap
//
//  Created by MACBOOK PRO on 11/16/22.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBOutlet weak var facebookLoginInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

