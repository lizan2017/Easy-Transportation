//
//  LoginViewController.swift
//  GMaps
//
//  Created by Lizan Pradhanang on 6/9/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {
    @IBOutlet weak var passwordTextField: UITextField!

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var signUpBtn: UIButton!
    var email:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = email
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.white])
        self.loginBtn.layer.cornerRadius = 20.0
        
        self.signUpBtn.layer.cornerRadius = 20.0
        self.signUpBtn.layer.borderColor = UIColor.gray.cgColor
        self.signUpBtn.layer.borderWidth = 1.0
        let tap:UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    func dissmissKeyboard(){
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        self.loggedIn()
    }
    

    @IBAction func signUp(_ sender: Any) {
        let sb = UIStoryboard(name: "SignUp", bundle: nil)
        let signUpVC = sb.instantiateViewController(withIdentifier: "signupVc")
        self.present(signUpVC, animated: true, completion: nil)
    }
   
    @IBAction func userLogin(_ sender: Any) {
        self.login()
    }
    
    func loggedIn(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchReq = try! context.fetch(LoginData.fetchRequest())
        if fetchReq.count != 0{
            let sb = UIStoryboard(name: "Main", bundle: nil)
            
            let mainVC = sb.instantiateViewController(withIdentifier: "main")
            self.present(mainVC, animated: true, completion: nil)
        }else{
            return
        }
    }
    
    
    func login(){
        if emailTextField.text! != "" && passwordTextField.text! != ""{
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {
                (currentUser, error) in
                
                if currentUser != nil{
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
                    let emailEntity = LoginData(context: context)
                    emailEntity.email = self.emailTextField.text
                    try? context.save()
                    
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    
                    let mainVC = sb.instantiateViewController(withIdentifier: "main")
                    self.present(mainVC, animated: true, completion: nil)
                }else{
                    if let myError = error?.localizedDescription{
                        let alert = UIAlertController(title: "Error", message: myError, preferredStyle: .alert)
                        let alertaction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(alertaction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
            })
            
            
            
        }
    }
    
}
