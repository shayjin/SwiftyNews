//
//  EditProfileViewController.swift
//  SwiftyNews
//
//  Created by Shay on 3/10/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EditProfileViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    
    let auth = Auth.auth()
    let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = Auth.auth().currentUser?.email
        
        nameTextField.text =
        auth.currentUser?.displayName
        
        database.child("User").child((auth.currentUser?.email?.replacingOccurrences(of: ".", with: ","))!).getData(completion:  { [self] error, snapshot in
            guard error == nil else {
              print(error!.localizedDescription)
              return;
            }
            let userName = snapshot?.value as? String ?? "Unknown"
            nameTextField.text = userName
          })
        
    }

    @IBAction func updateProfile(_ sender: UIButton) {
        database.child("User").child((auth.currentUser?.email?.replacingOccurrences(of: ".", with: ","))!).setValue(nameTextField.text)
    }
    
}
