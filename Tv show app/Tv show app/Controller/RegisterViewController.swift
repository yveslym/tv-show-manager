//
//  RegisterViewController.swift
//  Tv show app
//
//  Created by Yveslym on 4/9/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import UIKit
import KeychainSwift

class RegisterViewController: UIViewController, UITextFieldDelegate {

    // - MARK: IBOUTLETS
    
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    @IBOutlet weak var signupButtonTapped: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        signupButtonTapped.configureButton()
        self.hideKeyboardWhenTappedAround()
       usernameLabel.desActivateAutoCorrectAndCap()
        passwordLabel.desActivateAutoCorrectAndCap()
        emailLabel.desActivateAutoCorrectAndCap()
        nameLabel.desActivateAutoCorrectAndCap()
        usernameLabel.delegate = self
        emailLabel.delegate = self
        passwordLabel.delegate = self
        nameLabel.delegate = self
        
    }
    
    
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: TEXTFIELD DELEGATE
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == " " || textField.text == "" || textField.text == nil{
            textField.text = nil
            textField.placeholder = "You cannot leave this field blank..."
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.text = nil
    }
    
    // -MARK: IBACTIONS
    
    @IBAction func registerTapped(_ sender: UIButton){
        
        guard let email = emailLabel.text, let password = passwordLabel.text, let username = usernameLabel.text, let name = nameLabel.text else {
            let alert = UIAlertController(title: "Field Missing", message: "Please fill out all missing field", preferredStyle: .alert)
            let action = UIAlertAction(title: "Return", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if (emailLabel.text?.count)! < 3 || (passwordLabel.text?.count)! < 3 || (nameLabel.text?.count)! < 2 || (usernameLabel.text?.count)! < 3 {
            
            let alert = UIAlertController(title: "Imcompleted field", message: "some field are either too short or empty", preferredStyle: .alert)
            let action = UIAlertAction(title: "Return", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        User.currentUser.email = email
        User.currentUser.password = password
        User.currentUser.name = name
        User.currentUser.username = username
        ViewControllerUtils().showActivityIndicator(uiView: self.view)
        self.signUp {
            print("signed up")
        }
    }
    
    
    // - MARK: METHODS
    
    func signUp(completion:()->()){
        NetworkAdapter.request(target: .createUser, success: { (response) in
            
           
            
            if response.response?.statusCode == 201{
            do {
            let user = try JSONDecoder().decode(User.self, from: response.data)
                let keychain = KeychainSwift()
                
                keychain.accessGroup = "K7R433H2CL.yveslym-corp.showbix2"
                
                keychain.set(true, forKey: "isLogin")
                keychain.set(user.email!, forKey: "email")
                keychain.set(user.username ?? "", forKey: "username")
                keychain.set(user.authentication_token!, forKey: "token")
                keychain.set(true, forKey: "isLogin")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "home tab", sender: nil)
                }
            }
            catch{
                
            }
            }else{
                ViewControllerUtils().hideActivityIndicator(uiView: self.view)
                let alert = UIAlertController(title: "Couldn't create Account", message: "Either your username or Email is already taken, please try with different one", preferredStyle: .alert)
                let action = UIAlertAction(title: "Return", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }, error: { (error) in
            
        }) { (error) in
            
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        ViewControllerUtils().hideActivityIndicator(uiView: self.view)
    }

}
