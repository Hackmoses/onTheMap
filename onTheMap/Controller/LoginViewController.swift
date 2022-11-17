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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var emailTextFieldIsEmpty = true
    var passwordTextFieldIsEmpty = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailTextField.text = ""
        passwordTextField.text = ""
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    @IBAction func loginButtonClick(_ sender: Any) {
        UserLoggingIn(true)
        UdacityClientNetwork.login(email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func signUpButtonClick(_ sender: Any) {
        UserLoggingIn(true)
        UIApplication.shared.open(UdacityClientNetwork.Endpoints.udacitySignUp.url, options: [:], completionHandler: nil)
    }
    
    
    
    @IBAction func facebookLoginClick(_ sender: Any) {
        buttonEnabled(false, button: facebookLoginInButton)
    }
    
    func UserLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.buttonEnabled(false, button: self.loginButton)
            }
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.buttonEnabled(true, button: self.loginButton)
            }
        }
        DispatchQueue.main.async {
            self.emailTextField.isEnabled = !loggingIn
            self.passwordTextField.isEnabled = !loggingIn
            self.loginButton.isEnabled = !loggingIn
            self.signUpButton.isEnabled = !loggingIn
        }
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        UserLoggingIn(false)
        if success {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "login", sender: nil)
            }
        } else {
            DispatchQueue.main.async {
                alert(message: "Please check your credentials and/or internet connection", title: "Login Error")

            }
    }
        
    func alert(message: String, title: String) {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertVC, animated: true)
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField == emailTextField {
                let currentText = emailTextField.text ?? ""
                guard let stringRange = Range(range, in: currentText) else { return false }
                let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
                
                if updatedText.isEmpty && updatedText == "" {
                    emailTextFieldIsEmpty = true
                } else {
                    emailTextFieldIsEmpty = false
                }
            }
            
            if textField == passwordTextField {
                let currentText = passwordTextField.text ?? ""
                guard let stringRange = Range(range, in: currentText) else { return false }
                let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
                
                if updatedText.isEmpty && updatedText == "" {
                    passwordTextFieldIsEmpty = true
                } else {
                    passwordTextFieldIsEmpty = false
                }
            }
            
            if emailTextFieldIsEmpty == false && passwordTextFieldIsEmpty == false {
                buttonEnabled(true, button: loginButton)
            } else {
                buttonEnabled(false, button: loginButton)
            }
            
            return true
            
        }
        
            func textFieldShouldClear(_ textField: UITextField) -> Bool {
            buttonEnabled(false, button: loginButton)
            if textField == emailTextField {
                emailTextFieldIsEmpty = true
            }
            if textField == passwordTextField {
                passwordTextFieldIsEmpty = true
            }
            
            return true
        }
        
            func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
                nextField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
                loginButtonClick(loginButton ?? " ")
            }
            return true
        }
    }
    


}



extension UIViewController {
    
    // handling button response
    
    func buttonEnabled(_ enabled: Bool, button: UIButton) {
        if enabled {
            button.isEnabled = true
            button.alpha = 1.0
        } else {
            button.isEnabled = false
            button.alpha = 0.5
        }
    }
    
    // showing error/other alerts
    
    func showAlert(message: String, title: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
    // opens link in browser
    
    func openLink(_ url: String) {
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url) else {
            showAlert(message: "Cannot open link.", title: "Invalid Link")
            return
        }
        UIApplication.shared.open(url, options: [:])
    }

}

