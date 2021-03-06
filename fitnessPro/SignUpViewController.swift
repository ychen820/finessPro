//
//  SignUpViewController.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/18/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//

import UIKit
import FirebaseAuth
enum textFieldNames:String{
    case nameTextField = "name"
    case emailTextField = "email"
    case passwordTextField = "password"
}

class SignUpViewController: UIViewController {

    @IBOutlet weak var confirmTextfield: HoshiTextField!
    @IBOutlet weak var passwordTextfield: HoshiTextField!
    @IBOutlet weak var emailTextfield: HoshiTextField!
    @IBOutlet weak var nameTextfield: HoshiTextField!
    var textFields = Array<HoshiTextField>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields = [nameTextfield,emailTextfield,passwordTextfield,confirmTextfield]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
      var isEmpty = false
        validationLoop:for textfield in textFields{
            if textfield.text == "" {
                isEmpty = true
                if textfield == nameTextfield{
                   self.showAlert("Please fill in \(textFieldNames.nameTextField.rawValue)", title: "Confirm Input", comlete: { (action) in
                    textfield.becomeFirstResponder()
                   })
                   
                    break validationLoop
                }
                if textfield == passwordTextfield{
                    self.showAlert("Please fill in \(textFieldNames.passwordTextField.rawValue)", title: "Confirm input", comlete: { (action) in
                        textfield.becomeFirstResponder()
                    })
                    textfield.becomeFirstResponder()
                    break validationLoop

                }
                if textfield == emailTextfield{
                    self.showAlert("Please fill in \(textFieldNames.emailTextField.rawValue)", title: "Confirm input", comlete: { (action) in
                        textfield.becomeFirstResponder()
                    })
                    textfield.becomeFirstResponder()
                    break validationLoop
                    
                }
            }
        }
        if !isEmpty {
            if confirmTextfield.text != passwordTextfield.text{
                self.showAlert("Please Confirm Password", title: "Sign Up Error", comlete: nil)
                return
            }
            if let email = emailTextfield.text,  let password = passwordTextfield.text, let name=nameTextfield.text {
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, err) in
                    if let err = err{
                        self.showAlert(err.localizedDescription, title: "Sign Up Error", comlete: nil)
                    }
                    else{
                    if let userID = user?.uid{
                        let userDict = ["name":name,"email":email]
                        FirebaseManager.sharedInstance.userDatabaseRef.child(userID).setValue(userDict)
                       self.dismiss(animated: true, completion: nil)
                    }
                    }
                    
                })
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
