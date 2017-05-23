//
//  ViewController.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/18/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//
import UIKit
import FacebookCore
import FacebookLogin
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: YoshikoTextField!
    @IBOutlet weak var passwordTextfield: YoshikoTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    @IBAction func fBLogin(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                let credential = FacebookAuthProvider.credential(withAccessToken:accessToken.authenticationToken)
                Auth.auth().signIn(with: credential, completion: { (user, err) in
                    if let error = err{
                        print(error.localizedDescription)
                    }
                    else{
                        let userRef = FirebaseManager.sharedInstance.userDatabaseRef.child((user?.uid)!)
                        guard let name = user?.displayName else{
                            return
                        }
                        guard let photoURL = user?.photoURL?.absoluteString else{
                            return
                        }
                        
                        let userDict = ["email":name,"photoURL":photoURL]
                        userRef.setValue(userDict)
                        
                    }
                })
                
                
            }
        }
        
    }
    @IBAction func emailLogin(_ sender: UIButton) {
        if let tabCon = self.storyboard?.instantiateViewController(withIdentifier: "pageController"){
            self.present(tabCon, animated: true, completion: nil)
            /*
             guard let email = emailTextfield.text else { return  }
             guard let pwd = passwordTextfield.text else { return }
             Auth.auth().signIn(withEmail: email, password: pwd) { (userInfo, err) in
             if err != nil{
             self.showAlert(message: (err?.localizedDescription)!, title: "Login Error", comlete: nil)
             }
             else{
             if let tabCon = self.storyboard?.instantiateViewController(withIdentifier: "mainTab"){
             self.present(tabCon, animated: true, completion: nil)
             }
             }
             }
             */
            
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

