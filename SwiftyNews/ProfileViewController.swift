//
//  ProfileControllerViewController.swift
//  SwiftyNews
//
//  Created by Shay on 3/7/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {
    @IBOutlet var loginUsernameLabel: UILabel!
    @IBOutlet var loginUsernameTextField: UITextField!
    @IBOutlet var loginPasswordLabel: UILabel!
    @IBOutlet var loginPasswordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var createAccountButton: UIButton!
    @IBOutlet var forgotPasswordButtonn: UIButton!
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var retypePasswordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var signUpLogInButton: UIButton!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var retypePasswordLabel: UILabel!
    
    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var profileEmailLabel: UILabel!
    @IBOutlet var profileNameNameLabel: UILabel!
    @IBOutlet var profileEmailEmailLabel: UILabel!
    @IBOutlet var logOutButton: UIButton!
    @IBOutlet var editProfileButton: UIButton!
    
    @IBOutlet var likedArticlesLabel: UILabel!
    @IBOutlet var statusLogo: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var picture1: UIImageView!
    @IBOutlet var title1: UILabel!
    @IBOutlet var button2: UIButton!
    @IBOutlet var picture2: UIImageView!
    @IBOutlet var title2: UILabel!
    @IBOutlet var picture3: UIImageView!
    @IBOutlet var button3: UIButton!
    @IBOutlet var title3: UILabel!
    @IBOutlet var button4: UIButton!
    @IBOutlet var picture4: UIImageView!
    @IBOutlet var title4: UILabel!
    @IBOutlet var button5: UIButton!
    @IBOutlet var picture5: UIImageView!
    @IBOutlet var title5: UILabel!
    
    let auth = Auth.auth()
    let database = Database.database().reference()
    var likedNews: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
            view.addGestureRecognizer(tapGesture)
        
        if auth.currentUser != nil {
            statusLogo.text = "Profile"
            enable(page: "profile")
            
            database.child("User").child((auth.currentUser?.email?.replacingOccurrences(of: ".", with: ","))!).getData(completion:  { [self] error, snapshot in
                
                guard error == nil else {
                  print(error!.localizedDescription)
                  return;
                }
                
                let userName = snapshot?.value as? String ?? "Unknown"
                profileNameNameLabel.text = userName
              })
            
            profileEmailEmailLabel.text = auth.currentUser?.email
        } else {
            statusLogo.text = "Log In"
            enable(page: "login")
        }
    }
    
    func enable(page: String) {
        let loginElements = [loginUsernameLabel, loginUsernameTextField, loginPasswordLabel, loginPasswordTextField, loginButton, createAccountButton, forgotPasswordButtonn]
        let signUpElements = [emailTextField, nameTextField, passwordTextField, retypePasswordTextField, signUpButton, signUpLogInButton, emailLabel, nameLabel, passwordLabel, retypePasswordLabel]
        let profileElements = [profileNameLabel, profileEmailLabel, profileNameNameLabel, profileEmailEmailLabel,logOutButton, editProfileButton, likedArticlesLabel, scrollView]
        
        if (page == "login") {
            for element in loginElements {
                element!.isHidden = false
            }
            
            for element in signUpElements {
                element!.isHidden = true
            }
            
            for element in profileElements {
                element!.isHidden = true
            }
        } else if (page == "signup") {
            for element in loginElements {
                element!.isHidden = true
            }
            
            for element in signUpElements {
                element!.isHidden = false
            }
            
            for element in profileElements {
                element!.isHidden = true
            }
        } else if (page == "profile") {
            for element in loginElements {
                element!.isHidden = true
            }
            
            for element in signUpElements {
                element!.isHidden = true
            }
            
            for element in profileElements {
                element!.isHidden = false
            }
            
            
        }
    }
    
    
    func convertEmail(email: String) -> String {
        return email.replacingOccurrences(of: ".", with: ",")
    }
    
    @IBAction func goToSignUpPage(_ sender: UIButton) {
        emailTextField.text = ""
        nameTextField.text = ""
        passwordTextField.text = ""
        retypePasswordTextField.text = ""
        enable(page: "signup")
    }
    
    @IBAction func goToLogInPage(_ sender: UIButton) {
        enable(page: "login")
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
                } else {
                    let email = emailTextField.text!.replacingOccurrences(of: ".", with: ",")
                    database.child("User").child(email).setValue(nameTextField!.text!)
                    auth.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!)
                    self.viewDidLoad()
                }
            }
        }
    }
    
    @IBAction func login(_ sender: Any) {
        Auth.auth().signIn(withEmail: loginUsernameTextField.text!, password: loginPasswordTextField.text!) { [weak self] authResult, error in
            if (self!.auth.currentUser == nil) {
                let alertController = UIAlertController(title: "Invalid Credentials", message: "Error logging in: \(error!.localizedDescription)", preferredStyle: .alert)
                let action = UIAlertAction(title: "Continue", style: .default, handler: nil)
                alertController.addAction(action)
                self!.present(alertController, animated: true, completion: nil)
            } else {
                self!.viewDidLoad()
            }
        }
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        do {
            try auth.signOut()
            print("HI")
            self.viewDidLoad()
            self.viewWillAppear(true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func editProfile(_ sender: Any) {
        
    }
}
