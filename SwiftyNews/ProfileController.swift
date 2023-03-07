//
//  ProfileControllerViewController.swift
//  SwiftyNews
//
//  Created by Shay on 3/7/23.
//

import UIKit
import FirebaseAuth

class ProfileController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var retypePasswordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var signUpLogo: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var retypePasswordLabel: UILabel!
    
    let auth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let signUpElements = [emailTextField, nameTextField, passwordTextField, retypePasswordTextField, signUpButton, signUpLogo, emailLabel, nameLabel, passwordLabel, retypePasswordLabel]
        
        if let email = auth.currentUser?.email {
            print(email)
            
            for element in signUpElements {
                element!.isHidden = true
            }
        } else {
            
        }
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        if (passwordTextField.text != retypePasswordTextField.text) {
            let alertController = UIAlertController(title: "Unmatched Password", message: "Passwords are not matched!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Continue", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { [self] authResult, error in
                if let error = error {
                    let alertController = UIAlertController(title: "Error", message: "Error creating user: \(error.localizedDescription)", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Continue", style: .default, handler: nil)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                }
                
                Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!)
                print(Auth.auth().currentUser?.email)
                print("Test user created successfully")

            }

        }
    }
    


}
