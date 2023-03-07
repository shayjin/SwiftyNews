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
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var retypePasswordLabel: UILabel!
    
    @IBOutlet var statusLogo: UILabel!
    
    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var profileEmailLabel: UILabel!
    
    @IBOutlet var profileNameNameLabel: UILabel!
    @IBOutlet var profileEmailEmailLabel: UILabel!
    
    let auth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let signUpElements = [emailTextField, nameTextField, passwordTextField, retypePasswordTextField, signUpButton, emailLabel, nameLabel, passwordLabel, retypePasswordLabel]
        
        let profileElements = [profileNameLabel, profileEmailLabel, profileNameNameLabel, profileEmailEmailLabel]
        
        if let email = auth.currentUser?.email {
            print(email)
            
            for element in signUpElements {
                element!.isHidden = true
            }
            
            for element in profileElements {
                element!.isHidden = false
            }
            
            statusLogo.text = "Profile"
            profileNameNameLabel.text = auth.currentUser?.displayName
            profileEmailEmailLabel.text = auth.currentUser?.email
        } else {
            statusLogo.text = "Log In"
            
            for element in signUpElements {
                element!.isHidden = false
            }
            
            for element in profileElements {
                element!.isHidden = true
            }
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
                
                let changeRequest = auth.currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = nameLabel.text
                changeRequest?.commitChanges { error in
                  // ...
                }

            }

        }
    }
    


}
