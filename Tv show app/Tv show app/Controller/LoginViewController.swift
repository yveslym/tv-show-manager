//
//  LoginViewController.swift
//  Tv show app
//
//  Created by Yveslym on 3/30/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import UIKit
import KeychainSwift

class LoginViewController: UIViewController {

    // - MARK: IBOUTLET
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // - MARK: PROPERTIES
    
    
    // - MARK: IBACTION
    
    @IBAction func loginButtonTapped(_ sender: UIButton){
        
        guard let email = email.text, let password = password.text else {return}
        User.currentUser.email = email
        User.currentUser.password = password
        
        self.loginUser {
            
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton){
        self.loginUser {
            self.performSegue(withIdentifier: "register", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.configureButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LoginViewController{
    func loginUser(completion: ()->()){
        
        NetworkAdapter.request(target: .login, success: { (response) in
            if response.response?.statusCode == 200 {
            let user = try! JSONDecoder().decode(User.self, from: response.data)
            KeychainSwift().set(true, forKey: "isLogin")
            KeychainSwift().set(user.email!, forKey: "email")
            KeychainSwift().set(user.userName ?? "", forKey: "username")
            KeychainSwift().set(user.token!, forKey: "token")
            KeychainSwift().set(true, forKey: "isLogin")
                DispatchQueue.main.async {
                     self.performSegue(withIdentifier: "home tab", sender: nil)
                }
            }
            else if response.response?.statusCode == 400{
              let alert = UIAlertController(title: "Wrong Credential", message: "Either your email or password is incorrect", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Return", style: .cancel, handler: nil)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
                return
            }
           
            //handle if there's no internet
            
        }, error: { (error) in
            
        }) { (error) in
            
        }
    }
}
