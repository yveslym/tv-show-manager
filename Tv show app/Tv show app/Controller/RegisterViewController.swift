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
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: TEXTFIELD DELEGATE
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == ""{
            textField.text = nil
            textField.placeholder = "can't leave it blank..."
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = nil
    }
    
    // -MARK: IBACTIONS
    
    @IBAction func registerTapped(_ sender: UIButton){
        
        guard let _ = emailLabel, let _ = passwordLabel,let _ = usernameLabel, let _ = nameLabel else {
            let alert = UIAlertController(title: "Field Missing", message: "Please fill out all missing field", preferredStyle: .alert)
            let action = UIAlertAction(title: "Return", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return
            
        }
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
                KeychainSwift().set(true, forKey: "isLogin")
                KeychainSwift().set(user.email!, forKey: "email")
                KeychainSwift().set(user.userName ?? "", forKey: "username")
                KeychainSwift().set(user.token!, forKey: "token")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "home tab", sender: nil)
                }
            }
            catch{
                
            }
            }else{
                let alert = UIAlertController(title: "Couldn't create Account", message: "Either your username or Email is already taken, please try with different one", preferredStyle: .alert)
                let action = UIAlertAction(title: "Return", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            
            
        }, error: { (error) in
            
        }) { (error) in
            
        }
        
    }

}
